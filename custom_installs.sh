#!/bin/bash
# custom_installs.sh - any custom installations should be added to this script. 

# Orient to location of this script using this crazy, well-known command
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Get a timestamp for replacing existing files
timestamp=$(date +"%Y%m%d%H%M")

# Find all the regular files under the local 'home' directory
files=`find ./home -type f`

# Update the .Xdefaults using a template file to point to the location of this
# installed repo
for file in $files; do 

    # Cut the './home' from the file path
    localfilepath=`echo $file | cut -d'/' -f3-`

    # Check if file already exists, backup, then link
    homefilepath=$HOME/${localfilepath}
    if [ -f ${homefilepath} ]; then
        echo "${homefilepath} already exists."
        echo "Backing up as ${homefilepath}.${timestamp}." 
        mv ${homefilepath} ${homefilepath}.${timestamp}

    # If does not exist, make directory(ies), then link
    else
        echo "${homefilepath} does not exist."

        # Get the directory
        dir_only="$(dirname "${homefilepath}")"
        echo "Making directory ${dir_only}"
        mkdir -p ${dir_only}
    fi

    # Link the file
    echo "Linking to local file to ${script_dir}/${localfilepath}."
    #echo "ln -fs ${script_dir}/home/${localfilepath} ${homefilepath}"
    ln -fs ${script_dir}/home/${localfilepath} ${homefilepath}
    echo ""

done
