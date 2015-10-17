#! /bin/bash

# Run module install prep scripts.
# Written by Hector A Escobedo IV

source "$INITINATOR_LIB_PATH/error-handling.sh"

check_readable_dir "$MODULE_PATH"
check_writable_dir .

mkdir -p "./$MODULE_PATH"

for m in "$MODULES"
do
    if [ -x "$MODULE_PATH/$m/$m-install-prep.sh" ]
    then
	"$MODULE_PATH/$m/$m-install-prep.sh" || fail "Install prep script for '$m' module failed" 1
    else
	fail "Missing install prep script for '$m' module" 2
    fi
    cp -r "$MODULE_PATH/$m" "./$MODULE_PATH" || fail "Failed to copy module '$m' to initramfs" 1
done
