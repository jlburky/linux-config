#!/bin/bash

usage()
{
cat << EOF
Usage: $0 COMMAND

Set the user's Terminator emulator configuration.

COMMANDS:
-h, --help          This message.
-i, --install       Install terminator configs.
-u, --uninstall     Uninstall all configs executed by this script.

EOF
}

source globals.sh

# Check for max num of options
numargs=1
if [ "$#" -ne ${numargs} ]; then
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
            stowit "terminator"
            exit 0
            ;;
        -u|--uninstall)
            unstowit "terminator"
            exit 0
            ;;
        *)
            echo "Invalid option."
            exit 1
            ;;
     esac
done

exit 0
