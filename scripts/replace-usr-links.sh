#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

usage() 
{
cat << EOF
Usage: $(basename "$0") OLDUSER NEWUSER

Use this script after dropping the nvim bundle,
  nvim-lazy-mason-bundle-x.x.x.ver.tar,
into $HOME/.local/share/nvim .

Finds symbolic links containing OLDUSER in their target path and 
updates them to point to NEWUSER.

EOF
}

# Check correct number of args
if [[ $# -ne 2 ]]; then
    usage
    exit 1
fi

olduser="$1"
newuser="$2"

# Use 'read' with a null delimiter to handle spaces and special characters
# -type l: ensures we only process symbolic links
# -printf '%p\0%l\0': outputs link name and target separated by null bytes
found_any=false
while IFS= read -r -d '' linkname && IFS= read -r -d '' target; do
    found_any=true
    
    # Replace OLDUSER with NEWUSER in the target path
    new_target="${target//$olduser/$newuser}"

    # Only proceed if the target actually changed
    if [[ "$target" != "$new_target" ]]; then
        echo "Updating: $linkname"
        echo "  From: $target"
        echo "  To:   $new_target"

        # 3. Use 'ln -sf' to atomically update the link 
        # This is safer than 'rm' followed by 'ln'
        ln -sf "$new_target" "$linkname"
    fi
done < <(find . -type l -lname "*${olduser}*" -printf '%p\0%l\0')

if [ "$found_any" = true ]; then
    echo "Success!"
else
    echo "No links found containing '$olduser'."
fi

# Find all the files that contain '/home/OLDUSER' and replace with '/home/NEWUSER'
find . -type f -exec sed -i "s|/home/${olduser}/|/home/${newuser}/|g" {} +
