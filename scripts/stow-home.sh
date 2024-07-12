#!/bin/bash

usage()
{
cat << EOF
Usage: $0 [COMMANDS] PACKAGE

Wrapper that simplifies call to install and uninstall a single stow "package" in
a user's home directory.

COMMANDS:
-i, --install       Stow the package that follows this option.
-u, --uninstall     Unstow the package that follows this option.
-h, --help          This message.

EOF
}

source globals.sh

call_stow()
{
# Note: stow commands are expected to be executed from stow directory
# Always use the "restow" option, even if package isn't stow'd
command="stow --restow ${1} --target=${HOME}"
print_exec_command "${command}"
}

call_unstow()
{
# Note: stow commands are expected to be executed from stow directory
# stow commands are expected to be executed from stow directory
command="stow --delete ${1} --target=${HOME}"
print_exec_command "${command}"
}


# Check for max num of options
maxnumargs=2
if [ "$#" -gt "${maxnumargs}" ]; then
    usage
    exit 1
fi

# Gather options
for opt in "$@"; do
    case ${opt} in
        -h|--help)
            usage
            exit 0
            ;;
        -i|--install)
            call_stow "$2"
            exit 0
            ;;
        -u|--uninstall)
            call_unstow "$2"
            exit 0
            ;;
        *)
            echo "Invalid option."
            exit 1
            ;;
     esac
done
