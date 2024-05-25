#!/bin/bash
# custom_installs.sh - any custom installations should be added to this script. 
usage()
{
cat << EOF
Usage: $0 [options]

Customs installations for this repo including:
- Configuring and installing .Xdefaults for the urxvt terminal.
- Setting the .xsession for Qtile.

OPTIONS:
-h, --help          This message.

EOF
}

#---------- Configure and Install .Xdefaults ----------
setup_xdefaults()
{
# Update the .Xdefaults to point to this urxvt-vim-scrollback location using
# a template
template=${script_dir}/Xdefaults.template

# Set the path to the urxvt-vim-scrollback
folder_path=${script_dir}

# Search and replace the pattern in the template "/path/to" with user's path;
# note the trick, that since our variable uses "/" we use the @ delimiter since
# sed can use any character as a delimiter 
echo -e "Configuring .Xdefaults to point to ${folder_path}/urxvt-vim-scrollback."
echo -e "Creating .Xdefaults at ${script_dir}/home/.Xdefaults .\n"
sed -e "s@/path/to@${folder_path}@g" "${template}" > ./home/.Xdefaults
}

#---------- Install .xsession Link To .xsession.qtile ----------
install_xsession()
{
echo -e "Creating $HOME/.xsession link to local file, ${script_dir}/home/.xsession.qtile .\n"
ln -fs ${script_dir}/xsession.qtile $HOME/.xsession
}

# Globals
# Orient to location of this script using this crazy, well-known command
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Get a timestamp for replacing existing files
timestamp=$(date +"%Y%m%d%H%M")

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
            exit 0
            ;;
     esac
done

# Execute all customizations
setup_xdefaults
install_xsession
