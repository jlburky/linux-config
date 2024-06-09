#!/bin/bash
# install_qtile.sh - installs Qtile using a Python 3.10 virtual environment.
usage()
{
cat << EOF
Usage: $0 [options]

Installs Qtile v0.24.0 using a Python 3.10 virtual environment.

OPTIONS:
-h, --help          This message.
-rv, --remove-venv  Remove the Qtile virtual enviroment.

EOF
}

source globals.sh
venv_path=${top_dir}/venvs/qtile-venv

create_venv()
{
# Check that Python 3.10 exists
if ! command -v "python3.10" &> /dev/null
then
    echo "python3.10 could not be found!"
    exit 1
fi

# Create the Python virtual enviroment
echo -e "Creating the Qtile venv at:\n${venv_path}"
python3.10 -m venv ${venv_path}

# Activate the virtual enviroment
source ${venv_path}/bin/activate

# Install the dependencies using the requirements-frozen.txt
echo -e "Installing qtile from frozen requirements file:\n${venv_path}/requirements-frozen.txt"
pip install -r ${venv_path}/requirements-frozen.txt

deactivate
}

create_entry_file()
{
echo -e "Creating ${venv_path}/qtile-venv-entry"
cat > ${venv_path}/qtile-venv-entry <<EOF
#!/bin/bash

# This glue shell is only needed when you want to run Qtile within a virtualenv

source ${venv_path}/bin/activate
python ${venv_path}/bin/qtile \$*
EOF

chmod 755 ${venv_path}/qtile-venv-entry 
echo -e "Moving qtile-venv-entry file to /usr/local/bin/"
sudo mv ${venv_path}/qtile-venv-entry /usr/local/bin/
}

# Start all over and remove existing virtual env
remove_venv()
{
echo -e "Removing virtual environment located at:\n${venv_path}"
rm -rf ${venv_path}/bin
rm -rf ${venv_path}/include
rm -rf ${venv_path}/lib
rm -rf ${venv_path}/lib64
rm -rf ${venv_path}/pyvenv.cfg
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

create_venv
create_entry_file
exit 0
