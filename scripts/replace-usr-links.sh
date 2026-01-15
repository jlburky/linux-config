#!/bin/bash

usage()
{
cat << EOF
Usage: $0 OLDUSER NEWUSER

Finds any links that contain the OLDUSER name in the path, then recreates the link 
replacing it with the NEWUSER name.

EOF
}

olduser=$1
newuser=$2

# Check the max number of options
numargs=2
if [ "$# -ne "${numargs}" ]; then
    usage
    exit 1
fi

# Find any links under the current directory that contain the OLDUSER
# in the path
oldlinks=$(find ./ l -lname "*${olduser}*" -printf '%p:%l\n')
for link in ${oldlinks}; do
    linkname=$(echo "$link" | cut -d ':' -f1)
    path=$(echo "$link" | cut -d ':' -f2)

    # Remove the old link
    rm "$linkname"

    # Create the new link replacing OLDUSER with NEWUSER
    echo "Creating link: $linkname -> ${path//$olduser/$newuser}"
    ln -s "${path//$olduser/$newuser}" "$linkname"
done

echo "Success!"


    
