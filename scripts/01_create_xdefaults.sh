#!/bin/bash
# create_xdefaults.sh - creates the .Xdefaults file and places it in the this
# repos home directory for linking
usage()
{
cat << EOF
Usage: $0 [options]

Creates the .Xdefaults file that configures the urxvt terminal and places it in 
the this repos home directory for linking.

OPTIONS:
-h, --help          This message.

EOF
}

source globals.sh

#---------- Configure and Install .Xdefaults ----------
create_xdefaults()
{
# Update the .Xdefaults to point to this urxvt-vim-scrollback location using
# a template
template=${top_dir}/configurations/Xdefaults.template

# Search and replace the pattern in the template "/path/to" with user's path;
# note the trick, that since our variable uses "/" we use the @ delimiter since
# sed can use any character as a delimiter 
print_info "Configuring .Xdefaults to point to ${top_dir}/repos/urxvt-vim-scrollback plugin."
print_info "Creating .Xdefaults at ${top_dir}/home/.Xdefaults ."
command="sed -e "s@/path/to@${top_dir}/repos@g" "${template}" > ${top_dir}/home/.Xdefaults"
print_exec_command "$command"
}

# Check for max num of options
maxnumargs=1
if [ "$#" -gt $maxnumargs ]; then
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
        *)
            echo "Invalid option."
            exit 1
            ;;
     esac
done

# Execute all customizations
create_xdefaults
exit 0
