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
venv_path="${top_dir}/venvs/qtile-venv"
venv_entry="${top_dir}/stow/qtile/.local/bin/qtile-venv-entry"

# Add any dependencies to check here
check_deps()
{
# Check that Python 3.10 exists
if ! command -v "python3.10" &> /dev/null
then
    print_error "python3.10 could not be found!"
    exit 1
fi

# Check that dmenu executable exists
if ! command -v "dmenu" &> /dev/null
then
    print_error "dmenu could not be found!"
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

link_qtile_desktop()
{
# Offer to install system Qtile desktop entry
read -rp "Do you want install a system Qtile desktop entry to enter Qtile locally? (y/N)" ans
if [[ "${ans}" == [yY]  ]]; then
    print_info "Linking system Qtile desktop entry" 
    command="sudo ln -fs ${top_dir}/configurations/qtile-venv.desktop /usr/share/xsessions/qtile-venv.desktop"
    print_exec_command "$command"
else
    print_info "Skipping system Qtile desktop entry." 
fi
}

rm_qtile_desktop()
{
desktopfile="/usr/share/xsessions/qtile-venv.desktop"
# Check if Qtile desktop entry exists
if [ -f ${desktopfile} ]; then
    print_info "Removing system Qtile desktop entry" 
    command="sudo rm ${desktopfile}"
    print_exec_command "$command"
fi
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
            check_deps
            create_venv
            create_entry_file
            link_qtile_desktop
            stowit "qtile"
            print_info "You are now setup to use Qtile. Logout and then login
            using either RDP or your desktop manager (if installed)." 
            exit 0
            ;;
        -u|--uninstall)
            unstowit "qtile"
            remove_venv
            reset_entry_file
            rm_qtile_desktop
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
