#!/bin/bash
usage()
{
cat << EOF
Usage: $0 COMMAND

Installs Qtile v0.24.0 using a Python 3.10 virtual environment to run from an
XRDP session.

COMMANDS:
-i,  --install       Install configs to run Qtile from XRDP.
-u,  --uninstall     Uninstall all configs executed by this script.
-rv, --remove-venv   Remove only the Qtile virtual enviroment.
-h,  --help          This message.

EOF
}

source globals.sh
venv_path=${top_dir}/venvs/qtile-venv
venv_entry="${top_dir}/stow/qtile/.local/bin/qtile-venv-entry"

# Add any dependencies to check here
deps_check()
{
# Check that Python 3.10 exists
if ! command -v "python3.10" &> /dev/null
then
    print_error "python3.10 could not be found!"
    exit 1
fi
}

create_venv()
{
# Create the Python virtual enviroment
print_info "Creating the Qtile venv at:\n${venv_path}."
command="python3.10 -m venv ${venv_path}"
print_exec_command "$command"

# Activate the virtual enviroment
source "${venv_path}/bin/activate"

# Install the dependencies using the requirements-frozen.txt
print_info "Installing qtile from frozen requirements file:\n${venv_path}/requirements-frozen.txt."
command="pip install -r ${venv_path}/requirements-frozen.txt"
print_exec_command "$command"

deactivate
}

create_entry_file()
{
print_info "Creating ${venv_entry}."
cat > ${venv_entry} <<EOF
#!/bin/bash

# This glue shell is only needed when you want to run Qtile within a virtualenv

source ${venv_path}/bin/activate
python ${venv_path}/bin/qtile \$*
EOF

command="chmod 755 ${venv_entry}"
print_exec_command "$command"
}

reset_entry_file()
{
print_info "Resetting ${venv_entry}."
cat > ${venv_entry} <<EOF
#!/bin/bash

# This glue shell is only needed when you want to run Qtile within a virtualenv
EOF
}

# Start all over and remove existing virtual env
remove_venv()
{
echo -e "Removing virtual environment located at:\n${venv_path}"
command="rm -rf ${venv_path}/bin"
print_exec_command "$command"
command="rm -rf ${venv_path}/include"
print_exec_command "$command"
command="rm -rf ${venv_path}/lib"
print_exec_command "$command"
command="rm -rf ${venv_path}/lib64"
print_exec_command "$command"
command="rm -rf ${venv_path}/pyvenv.cfg"
print_exec_command "$command"
}

# Stow the qtile package
stow_qtile()
{
# Test if ~/.config/qtile exists
if [ -d "${HOME}/.config/qtile" ]; then
    command="mkdir -p ${HOME}/.config/qtile"
print_exec_command "$command"
fi

command="cd ${top_dir}/stow"
print_exec_command "$command"

command="../scripts/stow-home.sh qtile"
print_exec_command "$command"

cd - > /dev/null
}

# Unstow the xrvt package
unstow_qtile()
{
command="cd ${top_dir}/stow"
print_exec_command "$command"

command="../scripts/stow-home.sh --delete qtile"
print_exec_command "$command"

cd - > /dev/null
}

# Check for max num of options
numargs=1
if [ "$#" -ne ${numargs} ]; then
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
            deps_check
            create_venv
            create_entry_file
            stow_qtile
            exit 0
            ;;
        -u|--uninstall)
            unstow_qtile
            remove_venv
            reset_entry_file
            exit 0
            ;;
        -rv|--remove-venv)
            remove_venv
            exit 0
            ;;
        *)
            echo "Invalid option."
            exit 1
            ;;
     esac
done

exit 0
