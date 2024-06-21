#!/bin/bash
#
# link_home.sh - maps all the files under the `home/` directory to the user's
# Linux `$HOME` directory as links. If a file or link already exists, it will
# back it up with a timestamp extension (.YYYYMMDDHHMM) before creating the new
# link. To use, from the location of this script, execute:
# $ ./link_home.sh

usage()
{
cat << EOF
Usage: $0 [options]

Maps all the files under the this repo's home/ directory to the user's Linux
\$HOME directory as links. If a file or link already exists, it will back it up
with a timestamp extension (.YYYYMMDDHHMM) before creating the new link.

OPTIONS:
-h, --help              This message.
-rb, --remove-backups   Remove backup files (requires confirmation).

EOF
}

source globals.sh

link_files()
{
# Find all the regular files under the local 'home' directory
cd "${top_dir}" || exit 1
files=$(find ./home -type f)

for file in $files; do 

    # Cut the './home' from the file path
    localfilepath=`echo $file | cut -d'/' -f3-`

    # Check if file already exists, backup, then link
    homefilepath=$HOME/${localfilepath}
    if [ -f ${homefilepath} ]; then
        print_info "${homefilepath} already exists."
        print_info "Backing up as ${homefilepath}.${timestamp}." 
        command="mv ${homefilepath} ${homefilepath}.${timestamp}"
        print_exec_command "$command"

    # If does not exist, make directory(ies), then link
    else
        print_info "${homefilepath} does not exist."

        # Get the directory
        dir_only="$(dirname "${homefilepath}")"
        print_info "Making directory ${dir_only}"
        command="mkdir -p ${dir_only}"
        print_exec_command "$command"
    fi

    # Link the file
    print_info "Linking to local file to ${top_dir}/${localfilepath}."
    command="ln -fs ${top_dir}/home/${localfilepath} ${homefilepath}"
    print_exec_command "$command"

done
}

remove_backups()
{
# Find all the regular files udner the local 'home' directory
cd ${top_dir}
files=`find ./home -type f`

    for file in $files; do 
        # Cut the './home' from the file path
        localfile=`echo $file | cut -d'/' -f3-`

        # Find any backups
        if compgen -G "${HOME}/${localfile}.*" > /dev/null; then
            backups=`ls -1 ${HOME}/${localfile}.*`
            for backup in $backups; do
                read -p "Remove backup: ${backup}? (y/N)" confirm
                if [[ ${confirm} == [yY]  ]]; then
                    print_info "Done!"
                    command="rm -f ${backup}"
                    print_exec_command "$command"
                else
                   print_info "Skipping backup: ${backup} ." 
                fi
            done
        fi
    done
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
        -rb|--remove-backups)
            remove_backups
            exit 0
            ;;
        *)
            echo "Invalid option."
            exit 1
            ;;
     esac
done

# Execute the linking
link_files
exit 0
