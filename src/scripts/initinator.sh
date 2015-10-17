#! /bin/bash

# Build an init system.
# Written by Hector A Escobedo IV

if [ -z "$INITINATOR_INIT_CONFIG" ]
then
    INITINATOR_INIT_CONFIG=/etc/initinator.conf
fi

# Allow WORK_DIR to be set in the config
if [ ! -z "$INITINATOR_WORK_DIR" ]
then
    WORK_DIR="$INITINATOR_WORK_DIR"
elif [ -z "$WORK_DIR" ]
then
    WORK_DIR=/tmp
fi

if [ -z "$INITINATOR_PATH" ]
then
    INITINATOR_PATH=/usr/lib/initinator
fi

if [ -z "$INITINATOR_LIB_PATH" ]
then
    INITINATOR_LIB_PATH="$INITINATOR_PATH/script-libs"
fi

if [ -z "$INITINATOR_SCRIPT_PATH" ]
then
    INITINATOR_SCRIPT_PATH="$INITINATOR_PATH/scripts"
fi

if [ -z "$INITINATOR_TEMPLATE_PATH" ]
then
    INITINATOR_TEMPLATE_PATH="$INITINATOR_PATH/templates"
fi

# Allow MODULE_PATH to be set in the config
if [ ! -z "$INITINATOR_MODULE_PATH" ]
then
    MODULE_PATH="$INITINATOR_MODULE_PATH"
elif [ -z "$MODULE_PATH" ]
then
    MODULE_PATH="$INITINATOR_PATH/modules"
fi

if [ -z "$MODULES" ]
then
    MODULES="base"
fi

if [ ! -f "$INITINATOR_INIT_CONFIG" ]
then
    printf "Config file $INITINATOR_INIT_CONFIG not found\n"
    exit 2
else
    source "$INITINATOR_INIT_CONFIG"
fi

if [ ! -f "$INITINATOR_LIB_PATH/error-handling.sh" ]
then
    printf "Script library $INITINATOR_LIB_PATH/error-handling.sh not found\n"
    exit 2
else
    source "$INITINATOR_LIB_PATH/error-handling.sh"
fi

if [ ! -d "$INITINATOR_SCRIPT_PATH" ]
then
    printf "Script directory $INITINATOR_SCRIPT_PATH not found\n"
    exit 2
else
    PATH=$PATH:$INITINATOR_SCRIPT_PATH
fi

COMMAND="$1"
DEST_DIR="$2"
INITRAMFS="$3"
SRC_DIR="$WORK_DIR/initinator-work"

export_relevant_vars() {
    export INITINATOR_LIB_PATH
    export INITINATOR_SCRIPT_PATH
    export INITINATOR_TEMPLATE_PATH
    export MODULE_PATH
    export MODULES
    export INITRAMFS
    export SRC_DIR
    export DEST_DIR
    export INITRAMFS
}

# The actual work part
export_relevant_vars

if [ "$COMMAND" = 'build' ]
then
    trap 'fail "Build failed" $?' ERR
    check_root_priv
    check_writable_dir "$WORK_DIR"
    cd "$WORK_DIR"
    if [ -d 'initinator-work' ]
    then
	rm -r initinator-work
    fi
    mkdir initinator-work
    create-basedirs.sh initinator-work
    cd initinator-work
    install-modules.sh
    generate-init-script.sh
    chown -R root:root .
elif [ "$COMMAND" = 'install' ]
then
    trap 'fail "Install failed" $?' ERR
    check_root_priv
    cd "$WORK_DIR"
    install-initramfs.sh
elif [ "$COMMAND" = 'update' ]
then
    initinator.sh build
    initinator.sh install "$2" "$3"
else
    cat <<EOF
Usage: $0 <command>
Commands:
    build # build an initramfs
    install [built-dir] [installed-filename] # install an initramfs
    update [built-dir] [installed-filename] # build and then install
EOF
fi
