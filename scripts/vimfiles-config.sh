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
check_deps()
{
# Check that Python 3.10 exists
if ! command -v "python3.10" &> /dev/null
then
    print_error "python3.10 could not be found!"
    exit 1
fi
}

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
if [ -d ${dotvim} ]; then
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
print_exec_command "$command"
}

remove_vimfiles()
{
if [ -d "${vimfiles_path}" ]; then
    print_info "Removing clone at ${vimfiles_path}."
    command="rm -rf ${vimfiles_path}"
    print_exec_command "$command"
fi
}

clone_vimuserlocalfiles()
{
# Clone vimfiles repo under the linux-config
if [ -d ${vimuserlocalfiles_path} ]; then
    print_info "${vimuserlocalfiles_path} already exists, skipping clone."
else
    print_info "Cloning ${vimuserlocalfiles_repo} to ${vimuserlocalfiles_path}."
    command="git clone ${vimuserlocalfiles_repo} ${vimuserlocalfiles_path}"
    print_exec_command "$command"
fi
}

export_vimuserlocalfiles()
{
print_info "Exporting VIMUSERLOCALFILES to this repo in your $top_dir/stow/bash/.bashrc_local."
echo "export VIMUSERLOCALFILES=\"${vimuserlocalfiles_path}\"" >> "$top_dir/stow/bash/.bashrc_local"
}

remove_vimuserlocalfiles()
{
if [ -d "${vimuserlocalfiles_path}" ]; then
    print_info "Removing clone at ${vimuserlocalfiles_path}."
    command="rm -rf ${vimuserlocalfiles_path}"
    print_exec_command "$command"
fi

# TODO: Remove export in .bashrc_local
}

# Drop pynvim in stow/vimfiles directory to that it will be linked to
# ~/venvs/pynvim as expected in vimfiles/vimrc
venv_path="${top_dir}/stow/vimfiles/venvs/pynvim"

create_venv()
{
# Create the Python virtual enviroment
if [ -d ${venv_path} ]; then
    print_info "${venv_path} already exists, skipping."
else
    print_info "Creating the venv to support nvim at:\n${venv_path}."
    command="python3.10 -m venv ${venv_path}"
    print_exec_command "$command"
    
    # Activate the virtual enviroment
    source "${venv_path}/bin/activate"
    
    # Install the dependencies using the requirements-frozen.txt
    print_info "Installing pynvim to ${venv_path}."
    command="pip install pynvim"
    print_exec_command "$command"
    
    deactivate
fi
}

remove_venv()
{
if [ -d "${venv_path}" ]; then
    print_info "Removing virtual environment at ${venv_path}."
    command="rm -rf ${venv_path}"
    print_exec_command "$command"
fi
}

# Stow the vimfiles package
stow_vimfiles()
{
command="cd ${top_dir}/stow"
print_exec_command "$command"

command="../scripts/stow-home.sh --install vimfiles"
print_exec_command "$command"

cd - > /dev/null
}

# Unstow the vimfiles package
unstow_vimfiles()
{
command="cd ${top_dir}/stow"
print_exec_command "$command"

command="../scripts/stow-home.sh --uninstall vimfiles"
print_exec_command "$command"

cd - > /dev/null
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
            check_deps
            set_repos
            clone_vimfiles
            link_vimfiles
            clone_vimuserlocalfiles
            export_vimuserlocalfiles
            create_venv
            stow_vimfiles
            print_info "You are now setup to use the features for Vim and Neovim provided by vimfiles."
            exit 0
            ;;
        -u|--uninstall)
            unstow_vimfiles
            remove_venv
            remove_vimuserlocalfiles
            unlink_vimfiles
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
