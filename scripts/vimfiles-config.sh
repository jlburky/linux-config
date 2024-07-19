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

if ! command -v "nvim" &> /dev/null
then
    # Warn, but do not exit since nvim can be installed after
    print_warning "nvim could not be found!"
    read -rp "Press any key to continue..." ans
fi

if ! command -v "xclip" &> /dev/null
then
    # Warn, but do not exit since nvim can be installed after
    print_warning "xclip could not be found!"
    read -rp "Press any key to continue..." ans
fi

if ! command -v "rg" &> /dev/null
then
    # Warn, but do not exit since nvim can be installed after
    print_warning "rg (ripgrep) could not be found!"
    read -rp "Press any key to continue..." ans
fi

if ! command -v "fd" &> /dev/null
then
    # Warn, but do not exit since nvim can be installed after
    print_warning "fd (find alternative) could not be found!"
    read -rp "Press any key to continue..." ans
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

# Drop pynvim in stow/vimfiles directory to that it will be linked to
# ~/venvs/pynvim as expected in vimfiles/vimrc
venv_path="${top_dir}/stow/vimfiles/venvs/pynvim"
venv_link="${top_dir}/venvs/pynvim"

create_venv()
{
# Create the Python virtual enviroment
if [ -d "${venv_path}" ]; then
    print_info "${venv_path} already exists, skipping."
else
    print_info "Creating the venv to support nvim at:\n${venv_path}"
    command="python3.10 -m venv ${venv_path}"
    print_exec_command "${command}"
    
    # Activate the virtual enviroment
    source "${venv_path}/bin/activate"
    
    # Install the dependencies using the requirements-frozen.txt
    print_info "Installing pynvim to ${venv_path}."
    command="pip install pynvim"
    print_exec_command "${command}"
    
    deactivate

    # Add link in venvs directory to track it as a virtual environment 
    command="ln -fs ${venv_path} ${venv_link}"
    print_exec_command "${command}"
fi
}

remove_venv()
{
if [ -d "${venv_path}" ]; then
    print_info "Removing virtual environment at ${venv_path}."
    command="rm -rf ${venv_path}"
    print_exec_command "${command}"
fi

if [ -h "${venv_link}" ]; then
    command="rm -rf ${venv_link}"
    print_exec_command "${command}"
fi
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
            clone_vimuserlocalfiles
            export_vimuserlocalfiles
            stowit "bash"
            create_venv
            stowit "vimfiles"
            link_vimfiles
            print_info "You are now setup to use the features for Vim and Neovim provided by vimfiles."
            exit 0
            ;;
        -u|--uninstall)
            unlink_vimfiles
            unstowit "vimfiles"
            remove_venv
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
