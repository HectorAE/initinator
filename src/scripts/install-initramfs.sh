#! /bin/bash

# Install a built initramfs.
# Written by Hector A Escobedo IV

source "$INITINATOR_LIB_PATH/error-handling.sh"

if [ -z "$SRC_DIR" ]
then
    SRC_DIR=/tmp/initinator-work
fi

if [ -z "$DEST_DIR" ]
then
    DEST_DIR=/boot
fi

if [ -z "$INITRAMFS" ]
then
    INITRAMFS="initramfs.cpio.gz"
fi

check_root_priv
check_readable_dir "$SRC_DIR"
check_writable_dir "$DEST_DIR"

(cd "$SRC_DIR"; find . -print0 | cpio --null -ov --format=newc | gzip -9) > "$DEST_DIR/$INITRAMFS"
