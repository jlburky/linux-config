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
sed -e "s@/path/to@${folder_path}@g" "${template}" > ./home/.Xdefaults
