#!/bin/bash

usage()
{
cat << EOF
Usage: $0 COMMAND

Configures nvim using stand-alone configuration, separate from vim.

COMMANDS:
-h, --help          This message.
-i, --install       Install nvim configs.
-u, --uninstall     Uninstall all configs executed by this script.

EOF
}

source globals.sh

# Add any dependencies to check here
check_deps()
{
if ! command -v "nvim" &> /dev/null
then
    # Warn, but do not exit since nvim can be installed after
    print_warning "nvim could not be found!"
    read -rp "Press any key to continue..." ans
fi

# Check that Python 3 exists
if ! command -v "python3" &> /dev/null
then
    print_error "python3 could not be found!"
    exit 1
fi

if ! command -v "xclip" &> /dev/null
then
    # Warn, but do not exit since nvim can be installed after
    print_warning "Nvim utility, xclip, could not be found!"
    read -rp "Press any key to continue..." ans
fi

if ! command -v "rg" &> /dev/null
then
    # Warn, but do not exit since nvim can be installed after
    print_warning "Nvim utility, rg (ripgrep), could not be found!"
    read -rp "Press any key to continue..." ans
fi

if ! command -v "fdfind" &> /dev/null
then
    # Warn, but do not exit since nvim can be installed after
    print_warning "Nvim utility, fdfind (fd-find), could not be found!"
    read -rp "Press any key to continue..." ans
fi

if ! command -v "shellcheck" &> /dev/null
then
    # Warn, but do not exit since nvim can be installed after
    print_warning "Nvim utility, shellcheck (ShellCheck), could not be found!"
    read -rp "Press any key to continue..." ans
fi
}

# Set default repos 
lazy_repo="https://github.com/folke/lazy.nvim.git"
lazy_file="${top_dir}/stow/nvim/.config/nvim/lua/user/lazy.lua"

set_repos()
{
read -rp "Change default lazy repo: ${lazy_repo}? (y/N)" ans
if [[ "${ans}" == [yY]  ]]; then
    read -rp "Enter new lazy repo location: " newrepo 
    vimfiles_repo=${newrepo}
fi

# Update the lazy repo in the lazy.lua file
command="sed -i 's@${lazy_repo}@${newrepo}@g' ${lazy_file}"
print_exec_command "$command"
}

venv_path="${top_dir}/venvs/pynvim"
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
fi
}

remove_venv()
{
if [ -d "${venv_path}" ]; then
    print_info "Removing virtual environment at ${venv_path}."
    command="rm -rf ${venv_path}"
    print_exec_command "${command}"
fi
}

bashrc_local="${top_dir}/stow/bash/.bashrc_local"
set_nvim_alias()
{
print_info "Adding nvim alias using venv to your ${bashrc_local}."
echo "alias nvim='source ${venv_path}/bin/activate && nvim'" >> "${bashrc_local}"
}

remove_nvim_alias()
{
command="sed -i '/alias nvim/d' ${bashrc_local}"
print_exec_command "${command}"
}

install_fonts()
{
    stowit "fonts"
    command="fc-cache -fv > /dev/null"
    print_exec_command "$command"
}

# No need to use the function below, but here nevertheless
uninstall_fonts()
{
    unstowit "fonts"
    command="fc-cache -fv"
    print_exec_command "$command"
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
            create_venv
            set_nvim_alias
            stowit "nvim"
            install_fonts
            print_info "You are now setup to use the features Neovim."
            exit 0
            ;;
        -u|--uninstall)
            unstowit "nvim"
            remove_nvim_alias
            remove_venv
            exit 0
            ;;
        *)
            echo "Invalid option: ${opt}."
            exit 1
            ;;
     esac
done

exit 0
