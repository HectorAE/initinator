#! /bin/bash

# A library that provides robust error handling functions.
# Written by Hector A Escobedo IV

# Check that this process is running as the root user.
check_root_priv() {
    local selfname
    selfname=$(basename "$0")

    if [ $UID != 0 ]
    then
	fail "$selfname must be run as root" 1
    fi
}

# Check that the provided filepath is a readable directory.
#
# arg $1: a string; the filepath to check
check_readable_dir() {
    if [ ! -d "$1" ]
    then
	fail "There is no directory '$1'" 2
    elif [ ! -r "$1" ]
    then
	fail "Directory '$1' is not readable" 1
    fi
}

# Check that the provided filepath is a writable directory.
#
# arg $1: a string; the filepath to check
check_writable_dir() {
    if [ ! -d "$1" ]
    then
	fail "There is no directory '$1'" 2
    elif [ ! -w "$1" ]
    then
	fail "Directory '$1' is not writable" 1
    fi
}

# Report an error and exit with a nonzero exit status. Can be used with the
# 'trap' builtin to catch signals or errors in a block of statements and pass
# them up the call chain. It is an internal error if the exit status passed to
# fail() is 0, as this normally indicates a command returned with no errors.
#
# arg $1: a string; the error message
# arg $2: a number; the exit status
fail() {
    printf "$1\n"
    if [ -z "$2" ]
    then
	exit 1
    elif [ "$2" -eq 0 ]
    then
	printf "Tried to call fail() with exit code 0\n"
	exit 1
    else
	exit $2
    fi
}
