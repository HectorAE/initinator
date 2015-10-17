# The 'base' module contains basic functions and default variables that are
# always used in an init script.
# Written by Hector A Escobedo IV

# If necessary environment variables are unset, set them.
base_set_default_vars() {
    if [ -z "$BOOT_MOUNT" ]
    then
	BOOT_MOUNT=/mnt/boot
    fi

    if [ -z "$ROOT_MOUNT" ]
    then
	ROOT_MOUNT=/mnt/newroot
    fi

    if [ -z "$REAL_INIT" ]
    then
	REAL_INIT=/sbin/init
    fi

    if [ -z "$GOODBYE_MSG" ]
    then
	GOODBYE_MSG="Everything done. Goodbye."
    fi
}

# Print an error message and enter a rescue shell.
#
# arg $1: a string; the error message
base_rescue_shell() {
    printf "$1 Dropping to rescue shell.\n"
    exec sh
}

# Mount the standard Linux virtual filesystems.
base_mount_all_virtualfs() {
    mount -t proc none /proc || base_rescue_shell "Failed to mount /proc."
    mount -t sysfs none /sys || base_rescue_shell "Failed to mount /sys."
    mount -t devtmpfs none /dev || base_rescue_shell "Failed to mount /dev."
    mount -t tmpfs none /tmp || base_rescue_shell "Failed to mount /tmp."
}

# Undo the work of base_mount_all_virtualfs.
base_unmount_all_virtualfs() {
    umount /proc || base_rescue_shell "Failed to unmount /proc."
    umount /sys || base_rescue_shell "Failed to unmount /sys."
    umount /dev || base_rescue_shell "Failed to unmount /dev."
    umount /tmp || base_rescue_shell "Failed to unmount /tmp."
}

# Print parameters from the kernel command line, one per line.
base_print_kernel_params() {
    for p in $(cat /proc/cmdline)
    do
	printf "$p\n"
    done
}

# This is kind of messy, but it works. Other modules can always implement their
# own variable parsing from base_print_kernel_params.
base_parse_kernel_vars() {
    for v in $(base_print_kernel_params)
    do
	case "\${v}" in
	    boot_part=*)
		BOOT_PART="${v#*=}"
		;;
	    root=*)
		ROOT_PART="${v#*=}"
		;;
	    init=*)
		REAL_INIT="${v#*=}"
		;;
	esac
    done
}

# If the partitions are specified by LABEL or UUID, this built-in busybox tool
# will resolve them to device nodes.
base_normalize_partition_vars() {
    BOOT_PART="$(findfs $BOOT_PART)"
    ROOT_PART="$(findfs $ROOT_PART)"
}

# Mount the boot partition.
base_mount_boot() {
    mount "$BOOT_PART" "$BOOT_MOUNT" || base_rescue_shell "Failed to mount '$BOOT_PART' as '$BOOT_MOUNT'."
}

# Mount the real root partition.
base_mount_root() {
    mount "$ROOT_PART" "$ROOT_MOUNT" || base_rescue_shell "Failed to mount '$ROOT_PART' as '$ROOT_MOUNT'."
}

# Finish the initramfs process and boot into the real system.
base_boot_real_system() {
    printf "$GOODBYE_MSG\n"
    exec switch_root "$ROOT_MOUNT" "$REAL_INIT" || base_rescue_shell "Failed to switch to real root on '$ROOT_MOUNT'."
}
