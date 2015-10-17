# Contains the basic init hooks.
# Written by Hector A Escobedo IV

source "$MODULE_PATH/base/base.sh"

base_early_setup_priority=2
base_early_setup_hook() {
    base_mount_all_virtualfs
    base_parse_kernel_vars
    base_normalize_partition_vars
}

base_setup_priority=2
base_setup_hook() {
    base_set_default_vars
}

base_pre_mount_root_priority=9
base_pre_mount_root_hook() {
    base_mount_root
}

base_post_mount_root_priority=9
base_post_mount_root_hook() {
    return # Empty hook
}

base_final_priority=9
base_final_hook() {
    base_unmount_all_virtualfs
    base_boot_real_system
}
