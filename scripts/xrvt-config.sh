#!/bin/bash

usage()
{
cat << EOF
Usage: $0 COMMAND

Creates the .Xdefaults file that configures the rxvt terminal, places it in the
this repos stow/xrvt directory, then links it to the user's home directory using
stow.

COMMANDS:
-i, --install       Install configs.
-u, --uninstall     Uninstall all configs executed by this script.
-h, --help          This message.

EOF
}

source globals.sh

#---------- Configure and Install .Xdefaults ----------
xdefaults=${top_dir}/stow/xrvt/.Xdefaults

create_xdefaults()
{
# Update the .Xdefaults to point to this urxvt-vim-scrollback location using
# a template
template=${top_dir}/configurations/Xdefaults.template

# Search and replace the pattern in the template "/path/to" with user's path;
# note the trick, that since our variable uses "/" we use the @ delimiter since
# sed can use any character as a delimiter 
print_info "Configuring .Xdefaults to point to ${top_dir}/repos/urxvt-vim-scrollback plugin."
print_info "Creating .Xdefaults at ${xdefaults} ."
command="sed -e "s@/path/to@${top_dir}/repos@g" "${template}" > ${xdefaults}"
print_exec_command "$command"
}

offer_fontsize()
{
# Get the default font size
fontsize=$(grep --max-count=1 pixelsize "$template" | cut -d '=' -f2)

read -rp "Change default font size: ${fontsize}? (y/N)" ans
if [[ "${ans}" == [yY]  ]]; then
    read -rp "Enter new font size: " ans
    command="sed -i 's@pixelsize=${fontsize}@pixelsize=${ans}@g' ${xdefaults}"
    print_exec_command "$command"
    print_info "Done!"
fi
}

# Remove the generated .Xdefaults file
reset_xdefaults()
{
cat > ${xdefaults} <<EOF
# This file is intentionally blank to reserve it.
EOF
}


# Stow the xrvt package
stow_xrvt()
{
command="cd ${top_dir}/stow"
print_exec_command "$command"

command="../scripts/stow-home.sh xrvt"
print_exec_command "$command"

cd - > /dev/null
}

# Unstow the xrvt package
unstow_xrvt()
{
command="cd ${top_dir}/stow"
print_exec_command "$command"

command="../scripts/stow-home.sh --delete xrvt"
print_exec_command "$command"

cd - > /dev/null
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
            create_xdefaults
            offer_fontsize
            stow_xrvt
            exit 0
            ;;
        -u|--uninstall)
            unstow_xrvt 
            reset_xdefaults
            exit 0
            ;;
        *)
            echo "Invalid option."
            exit 1
            ;;
     esac
done
