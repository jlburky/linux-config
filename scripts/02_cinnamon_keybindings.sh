#!/bin/bash
# cinnamon_keybindings.sh - captures or installs the Cinnamon keybindings.
usage()
{
cat << EOF
Usage: $0 [options]

Uses the stored keybindings.dconf files to install custom keybindings for the
Cinnamon desktop environment.

OPTIONS:
-i, --install       Install the keybindings from the stored configuration file.
-c, --capture       Capture the keybindings to the stored configuration file.
-h, --help          This message.

EOF
}

source globals.sh
keybindings=${top_dir}/configurations/keybindings.dconf

install_keybindings()
{
echo -e "Installing keybindings using the configuration file:\n${keybindings}"
dconf load /org/cinnamon/desktop/keybindings/ < ${keybindings}
}

capture_keybindings()
{
echo -e "Capturing keybindings to the configuration file:\n${keybindings}"
dconf dump /org/cinnamon/desktop/keybindings/ > ${keybindings}
}

# Check for max num of options
maxnumargs=1
if [ "$#" -ne $maxnumargs ]; then
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
