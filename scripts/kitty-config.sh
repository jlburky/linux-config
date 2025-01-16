#!/bin/bash

usage()
{
cat << EOF
Usage: $0 COMMAND

Configures the kitty terminal then links it to the user's home directory using
stow.

COMMANDS:
-i, --install       Install configs.
-u, --uninstall     Uninstall all configs executed by this script.
-h, --help          This message.

EOF
}

source globals.sh

kitty_conf=${top_dir}/stow/kitty/.config/kitty/kitty.conf

check_deps()
{
# rxvt comes in varying package names and executable names
if ! command -v kitty &> /dev/null
then
    print_error "kitty could not be found!"
    exit 1
fi
}

offer_fontsize()
{
# Get the default font size
fontsize=$(tr -s ' ' < ${kitty_conf} | grep ^font_size | cut -d ' ' -f2)

read -rp "Change default font size: ${fontsize}? (y/N)" ans
if [[ "${ans}" == [yY]  ]]; then
    read -rp "Enter new font size: " ans
    command="sed -i 's@font_size ${fontsize}@font_size ${ans}@g' ${kitty_conf}"
    print_exec_command "$command"
    print_info "Done!"
fi
}

install_fonts()
{
    stowit "fonts"
    command="fc-cache -fv"
    print_exec_command "$command"
}

# No need to use the function below, but here nevertheless
uninstall_fonts()
{
    unstowit "fonts"
    command="fc-cache -fv"
    print_exec_command "$command"
}

# Check for max num of options
numargs=1
if [ "$#" -ne ${numargs} ]; then
    usage
    exit 1
fi

for opt in "$@"; do
    case ${opt} in
        -h|--help)
            usage
            exit 0
            ;;
        -i|--install)
            check_deps
            offer_fontsize
            stowit "kitty" 
            install_fonts
            exit 0
            ;;
        -u|--uninstall)
            unstowit "kitty" 
            exit 0
            ;;
        *)
            echo "Invalid option."
            exit 1
            ;;
     esac
done
