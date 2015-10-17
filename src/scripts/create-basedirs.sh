#! /bin/bash

# Create the base directory layout of a basic filesystem.
# Written by Hector A Escobedo IV

source "$INITINATOR_LIB_PATH/error-handling.sh"

BASE="$1"

if [ -z "$BASE" ]
then
    fail 'No base directory argument given' 1
fi

create_real_dirs() {
    trap 'fail "Failed to create real base directories" $?' ERR
    mkdir "$BASE/bin"
    mkdir "$BASE/etc"
    mkdir "$BASE/lib"
    mkdir "$BASE/lib64"
    mkdir "$BASE/root"
    mkdir "$BASE/usr"
}

create_mountpoints() {
    trap 'fail "Failed to create mountpoint base directories" $?' ERR
    mkdir "$BASE/dev"
    mkdir "$BASE/mnt"
    mkdir "$BASE/proc"
    mkdir "$BASE/sys"
    mkdir "$BASE/tmp"
}

create_bin_symlinks() {
    trap 'fail "Failed to create symbolic links to $BASE/bin" $?' ERR
    ln -T -s "bin" "$BASE/sbin"
    ln -T -s "../bin" "$BASE/usr/bin"
    ln -T -s "../bin" "$BASE/usr/sbin"
}

check_writable_dir "$BASE"

create_real_dirs
create_mountpoints
create_bin_symlinks
