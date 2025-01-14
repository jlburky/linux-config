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

# Drop pynvim in stow/vimfiles directory to that it will be linked to
# ~/venvs/pynvim as expected in vimfiles/vimrc
venv_path="${top_dir}/stow/vimfiles/venvs/pynvim"
venv_link="${top_dir}/venvs/pynvim"

# TODO: leaving this here, though it's not used yet, anticipating I will want to
# use it.
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
            #create_venv
            stowit "nvim"
            print_info "You are now setup to use the features Neovim."
            exit 0
            ;;
        -u|--uninstall)
            unstowit "nvim"
            #remove_venv
            exit 0
            ;;
        *)
            echo "Invalid option."
            exit 1
            ;;
     esac
done

exit 0
