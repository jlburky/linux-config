#!/bin/bash
# custom_installs.sh - any custom installations should be added to this script. 

# Orient to location of this script using this crazy, well-known command
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Get a timestamp for replacing existing files
timestamp=$(date +"%Y%m%d%H%M")

#---------- Configure and Install .Xdefaults ----------
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

#---------- Install .xsession Link To .xsession.qtile ----------
# Check if file already exists, backup, then link
homefilepath=$HOME/.xsession
if [ -f ${homefilepath} ]; then
    echo "${homefilepath} already exists."
    echo "Backing up as ${homefilepath}.${timestamp}." 
    mv ${homefilepath} ${homefilepath}.${timestamp}
fi

echo -e "Creating $HOME/.xsession link to local file, ${script_dir}/home/.xsession.qtile .\n"
ln -fs ${script_dir}/home/.xsession.qtile ${homefilepath}
