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
-sr, --set-repos    Interactively change the location of the Git repo for 
                    vimfile and vimuserlocalfiles before configuration.

EOF
}

source globals.sh

# Set default repos 
vimfiles_repo=https://github.com/drmikehenry/vimfiles.git
vimuserlocalfiles_repo=https://github.com/jlburky/vimuserlocalfiles.git

# Provide option to use alternate repos for vimfile and vimuserlocalfiles
set_repos()
{
read -rp "Enter new vimfile repo location: " newrepo 
vimfiles_repo=${newrepo}

read -rp "Enter new vimuserlocalfile repo location: " newrepo 
vimuserlocalfiles_repo=${newrepo}
}

configure_vimfiles()
{
# Clone vimfiles repo under the linux-config
vimfiles_path="${top_dir}/repos/vimfiles"
if [ -d "${vimfiles_path}" ]; then
    print_info "${vimfiles_path} already exists, skipping clone."
else
    print_info "Cloning ${vimfiles_repo} to ${vimfiles_path}."
    command="git clone ${vimfiles_repo} ${vimfiles_path}"
    print_exec_command "$command"
fi

# Link user's $HOME/.vim to this repo; check if file already exists, backup, 
# then link
dotvimfile="$HOME/.vim"
if [ -d ${dotvimfile} ]; then
    print_info "${dotvimfile} already exists. Backing up as ${dotvimfile}.${timestamp}." 
    command="mv ${dotvimfile} ${dotvimfile}.${timestamp}"
    print_exec_command "$command"
fi

# Link to the repo
print_info "Linking to user's .vim file to ${top_dir}/repos/vimfile."
command="ln -fs ${top_dir}/repos/vimfiles $HOME/.vim"
print_exec_command "$command"

# Message to user to ensure runtime in .vimrc
print_warning "Ensure your ~/.vimrc declares 'runtime vimrc'."
}

configure_vimuserlocalfiles()
{
# Clone vimfiles repo under the linux-config
vimuserlocalfiles_path="${top_dir}/repos/vimuserlocalfiles"
if [ -d ${vimuserlocalfiles_path} ]; then
    print_info "${vimuserlocalfiles_path} already exists, skipping clone."
else
    print_info "Cloning ${vimuserlocalfiles_repo} to ${vimuserlocalfiles_path}."
    command="git clone ${vimuserlocalfiles_repo} ${vimuserlocalfiles_path}"
    print_exec_command "$command"
fi

print_info "Exporting VIMUSERLOCALFILES to this repo in your $top_dir/home/.bashrc_local."
echo "export VIMUSERLOCALFILES=\"${vimuserlocalfiles_path}\"" >> "$top_dir/home/.bashrc_local"
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
        -sr|--set-repos)
            set_repos
            ;;
        *)
            echo "Invalid option."
            exit 1
            ;;
     esac
done

configure_vimfiles
configure_vimuserlocalfiles
exit 0
