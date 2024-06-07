#!/bin/bash
#
# configure_vim.sh - configures vim using Doc Mikes vimfiles and a user's 
# vimuserlocal files. 

usage()
{
cat << EOF
Usage: $0 [options]

Configures vim using Doc Mikes vimfiles and a user's vimuserlocal files. 

OPTIONS:
-h, --help          This message.

EOF
}

source globals.sh

# Set default repos 
vimfiles_repo=git@github.com:drmikehenry/vimfiles.git
vimuserlocalfiles=git@github:jlburky/vimuserlocalfiles.git

# Provide option to use alternate repos for vimfile and vimuserlocalfiles
#set_repos()

configure_vimfiles()
{

# Clone vimfiles repo under the linux-config
# TODO: should we check if directory already exists?
#echo -e "Cloning ${vimfiles_repo} to ${top_dir}/repos/vimfiles"
#git clone ${vimfiles_repo} ${top_dir}/repos/vimfiles

# Link user's $HOME/.vim to this repo; check if file already exists, backup, 
# then link
dotvimfile="$HOME/.vim"
echo "${dotvimfile}"
if [ -d ${dotvimfile} ]; then
    echo "${dotvimfile} already exists."
    echo "Backing up as ${dotvimfile}.${timestamp}." 
    mv ${dotvimfile} ${dotvimfile}.${timestamp}
fi

# Link to the repo
echo "Linking to user's .vim file to ${top_dir}/repos/vimfiles"
ln -fs ${top_dir}/repos/vimfiles $HOME/.vim
echo ""

# Message to user to ensure runtime in .vimrc
echo -e "Ensure your ~/.vimrc declares 'runtime vimrc'."
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
        *)
            echo "Invalid option."
            exit 0
            ;;
     esac
done

configure_vimfiles
exit 0
