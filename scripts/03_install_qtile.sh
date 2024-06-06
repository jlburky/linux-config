#!/bin/bash
# install_qtile.sh - installs Qtile using a Python 3.10 virtual environment.
usage()
{
cat << EOF
Usage: $0 [options]

Installs Qtile v0.24.0 using a Python 3.10 virtual environment.

OPTIONS:
-h, --help          This message.

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
pip install -r <requirements-frozen.txt>

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
        *)
            echo "Invalid option."
            exit 0
            ;;
     esac
done

create_venv
exit 0
