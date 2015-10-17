#! /bin/bash

# Prepare the initramfs working directory for the 'base' module.
# Written by Hector A Escobedo IV

source "$INITINATOR_LIB_PATH/error-handling.sh"

mkdir mnt/boot || fail 'Failed to create mnt/boot dir' 1
mkdir mnt/newroot || fail 'Failed to create mnt/newroot dir' 1

cp /bin/busybox bin || fail 'Failed to copy busybox binary' 1
