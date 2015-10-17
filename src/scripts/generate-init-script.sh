#! /bin/bash

# Generate an init script for an initramfs.
# Written by Hector A Escobedo IV

cat "$INITINATOR_TEMPLATE_PATH/init.header" > init
printf "MODULE_PATH=$MODULE_PATH\nMODULES=$MODULES\n" >> init
cat "$INITINATOR_TEMPLATE_PATH/init.footer" >> init

chmod +x init
