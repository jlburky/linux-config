#!/bin/bash

usage()
{
cat << EOF
Usage: $0 COMMAND

Configures vim and nvim using Doc Mikes vimfiles and a user's vimuserlocal files. 

COMMANDS:
-h, --help          This message.
-i, --install       Install vim configs.
-u, --uninstall     Uninstall all configs executed by this script.

EOF
}

source globals.sh

# Set default repos 
vimfiles_repo="https://github.com/drmikehenry/vimfiles.git"
vimuserlocalfiles_repo="https://github.com/jlburky/vimuserlocalfiles.git"

# Set paths to clones
vimfiles_path="${top_dir}/repos/vimfiles"
vimuserlocalfiles_path="${top_dir}/repos/vimuserlocalfiles"

# Add any dependencies to check here
#check_deps() {}

# Provide option to use alternate repos for vimfile and vimuserlocalfiles
set_repos()
{
read -rp "Change default vimfiles repo: ${vimfiles_repo}? (y/N)" ans
if [[ "${ans}" == [yY]  ]]; then
    read -rp "Enter new vimfile repo location: " newrepo 
    vimfiles_repo=${newrepo}
fi

read -rp "Change default vimuserlocalfiles repo: ${vimuserlocalfiles_repo}? (y/N)" ans
if [[ "${ans}" == [yY]  ]]; then
    read -rp "Enter new vimuserlocalfile repo location: " newrepo 
    vimuserlocalfiles_repo=${newrepo}
fi
}

clone_vimfiles()
{
# Clone vimfiles repo under the linux-config
if [ -d "${vimfiles_path}" ]; then
    print_info "${vimfiles_path} already exists, skipping clone."
else
    print_info "Cloning ${vimfiles_repo} to ${vimfiles_path}."
    command="git clone ${vimfiles_repo} ${vimfiles_path}"
    print_exec_command "$command"
fi
}

# Links cannot be "stowed", so we'll have to handle $HOME/.vim linking to the
# vimfiles repo ourselves
dotvim="${HOME}/.vim"
unlink_vimfiles()
{
if [ -d "${dotvim}" ]; then
    print_info "Removing existing ${dotvim}."
    command="rm -f ${dotvim}"
    print_exec_command "$command"
fi
}

link_vimfiles()
{
# Link stow/vimfiles/.vim to this repo
unlink_vimfiles

print_info "Linking ${dotvim} to ${top_dir}/repos/vimfile."
command="ln -fs ${top_dir}/repos/vimfiles ${dotvim}"
print_exec_command "${command}"
}

remove_vimfiles()
{
if [ -d "${vimfiles_path}" ]; then
    print_info "Removing clone at ${vimfiles_path}."
    command="rm -rf ${vimfiles_path}"
    print_exec_command "${command}"
fi
}

clone_vimuserlocalfiles()
{
# Clone vimfiles repo under the linux-config
if [ -d "${vimuserlocalfiles_path}" ]; then
    print_info "${vimuserlocalfiles_path} already exists, skipping clone."
else
    print_info "Cloning ${vimuserlocalfiles_repo} to ${vimuserlocalfiles_path}."
    command="git clone ${vimuserlocalfiles_repo} ${vimuserlocalfiles_path}"
    print_exec_command "${command}"
fi
}

bashrc_local="${top_dir}/stow/bash/.bashrc_local"

export_vimuserlocalfiles()
{
print_info "Exporting VIMUSERLOCALFILES to this repo in your ${bashrc_local}."
echo "export VIMUSERLOCALFILES=\"${vimuserlocalfiles_path}\"" >> "${bashrc_local}"
}

remove_vimuserlocalfiles()
{
if [ -d "${vimuserlocalfiles_path}" ]; then
    print_info "Removing clone at ${vimuserlocalfiles_path}."
    command="rm -rf ${vimuserlocalfiles_path}"
    print_exec_command "${command}"
fi
}

remove_export()
{
command="sed -i '/VIMUSERLOCALFILES/d' ${bashrc_local}"
print_exec_command "${command}"
}

# Check for max num of options
numargs=1
if [ "$#" -ne $numargs ]; then
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
        -i|--install)
            #check_deps
            set_repos
            clone_vimfiles
            clone_vimuserlocalfiles
            export_vimuserlocalfiles
            stowit "bash"
            stowit "vimfiles"
            link_vimfiles
            print_info "You are now setup to use the features for Vim and Neovim provided by vimfiles."
            print_info "Exit this shell and enter a new shell to set environmental variables before launching vim."
            exit 0
            ;;
        -u|--uninstall)
            unlink_vimfiles
            unstowit "vimfiles"
            remove_export
            remove_vimuserlocalfiles
            remove_vimfiles
            exit 0
            ;;
        *)
            echo "Invalid option."
            exit 1
            ;;
     esac
done

exit 0
