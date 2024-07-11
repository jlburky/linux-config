#!/bin/bash
usage()
{
cat << EOF
Usage: $0 COMMAND

Uses the stored keybindings.dconf files to install custom keybindings for the
Cinnamon desktop environment.

COMMAND:
-i, --install       Install the keybindings from the stored configuration file.
-c, --capture       Capture the keybindings to the stored configuration file.
-h, --help          This message.

EOF
}

source globals.sh
keybindings=${top_dir}/configurations/keybindings.dconf

install_keybindings()
{
print_info "Installing keybindings using the configuration file:\n${keybindings}"
command="dconf load /org/cinnamon/desktop/keybindings/ < ${keybindings}"
print_exec_command "$command"
}

capture_keybindings()
{
print_info "Capturing keybindings to the configuration file:\n${keybindings}"
command="dconf dump /org/cinnamon/desktop/keybindings/ > ${keybindings}"
print_exec_command "$command"
}

# Check for max num of options
numargs=1
if [ "$#" -ne $numargs ]; then
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
            install_keybindings
            exit 0
            ;;
        -c|--capture)
            capture_keybindings
            exit 0
            ;;
        *)
            echo "Invalid option."
            exit 1
            ;;
     esac
done

exit 0
