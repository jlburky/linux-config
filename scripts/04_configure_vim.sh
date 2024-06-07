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
vimuserlocalfiles=git@github.com:jlburky/vimuserlocalfiles.git

# Provide option to use alternate repos for vimfile and vimuserlocalfiles
#set_repos()

configure_vimfiles()
{

# Clone vimfiles repo under the linux-config
vimfiles_path="${top_dir}/repos/vimfiles"
if [ -d ${vimfiles_path} ]; then
    echo -e "${vimfiles_path} already exists, skipping clone.\n"
else
    echo -e "Cloning ${vimfiles_repo} to ${vimfiles_path}.\n"
    git clone ${vimfiles_repo} ${vimfiles_path}
fi
echo ""

# Link user's $HOME/.vim to this repo; check if file already exists, backup, 
# then link
dotvimfile="$HOME/.vim"
if [ -d ${dotvimfile} ]; then
    echo "${dotvimfile} already exists."
    echo "Backing up as ${dotvimfile}.${timestamp}." 
    mv ${dotvimfile} ${dotvimfile}.${timestamp}
fi

# Link to the repo
echo -e "Linking to user's .vim file to ${top_dir}/repos/vimfile.\n"
ln -fs ${top_dir}/repos/vimfiles $HOME/.vim

# Message to user to ensure runtime in .vimrc
echo -e "Ensure your ~/.vimrc declares 'runtime vimrc'.\n"
}

configure_vimuserlocalfiles()
{
# Clone vimfiles repo under the linux-config
vimuserlocalfiles_path="${top_dir}/repos/vimuserlocalfiles"
if [ -d ${vimuserlocalfiles_path} ]; then
    echo -e "${vimuserlocalfiles_path} already exists, skipping clone.\n"
else
    echo -e "Cloning ${vimfiles_repo} to ${vimuserlocalfiles_path}.\n"
    git clone ${vimfiles_repo} ${vimuserlocalfiles_path}
fi

echo -e "Exporting VIMUSERLOCALFILES to point to this repo. You may want to tidy up."
echo "export VIMUSERLOCALFILES=\"${vimuserlocalfiles_path}\"" >> ~/.bashrc
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
configure_vimuserlocalfiles
exit 0