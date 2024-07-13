#!/bin/bash

usage()
{
cat << EOF
Usage: $0 [options]

# Installs and configures additions for neovim beyond that provided by Doc 
# Mike's vimfiles.

OPTIONS:
-h, --help          This message.
-i, --install       Install Neovim configs.
-u, --uninstall     Uninstall all configs executed by this script.

EOF
}

source globals.sh

# Set default repos
lua_language_server_repo=https://github.com/sumneko/lua-language-server

set_repos()
{
read -rp "Change default lua-language-server repo: ${lua_language_server_repo}? (y/N)" ans
if [[ "${ans}" == [yY]  ]]; then
	read -rp "Enter new lua-language-server repo location: " newrepo 
	lua_language_server_repo=${newrepo}
fi
}

# Can this be installed into a venv? How about the existing pynvim venv?
#install_python_language_server()
#{
#print_info "Installing python-language-server package to native Python 3, locally."  
#command="python3 -m pip install python-language-server[all]"
#print_exec_command "$command"
#}

# Clone lua language server repo under the linux-config/repos
lua_language_server_path="$top_dir/repos/lua-language-server"
install_lua_language_server()
{
if [ -d "$lua_language_server_path" ]; then
    print_info "$lua_language_server_path already exists, skipping clone."
else
    print_info "Cloning ${lua_language_server_repo} to ${lua_language_server_path}."
    command="git clone $lua_language_server_repo $lua_language_server_path"
    print_exec_command "${command}"
fi

# Build and install the server
print_info "Starting build of lua-language-server."
command="cd $lua_language_server_path || exit 1"
print_exec_command "${command}"
command="git submodule update --init --recursive"
print_exec_command "${command}"
command="cd 3rd/luamake || exit 1"
print_exec_command "${command}"
command="compile/install.sh"
print_exec_command "${command}"
command="cd $lua_language_server_path || exit 1"
print_exec_command "${command}"
command="./3rd/luamake/luamake rebuild"
print_exec_command "${command}"
}

remove_lua_language_server()
{
if [ -d "${lua_language_server_path}" ]; then
    print_info "Removing clone at ${lua_language_server_path}."
    command="rm -rf ${lua_language_server_path}"
    print_exec_command "${command}"
fi
}

# This installation adds an alias call 'luamake' to the user's .bashrc file;
# move this to .bashrc_local
bashrc_local="${top_dir}/stow/bash/.bashrc_local"
move_luamake_alias()
{
    print_info "Moving luamake alias from .bashrc to .bashrc_local"
    lua_alias=$(grep "alias luamake" "$HOME/.bashrc")
    command="echo '$lua_alias' >> ${bashrc_local}"
    print_exec_command "${command}"
    command="sed -i '/alias luamake/d' $HOME/.bashrc"
    print_exec_command "${command}"
}

remove_luamake_alias()
{
command="sed -i '/alias luamake/d' ${bashrc_local}"
print_exec_command "${command}"
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
        -i|--install)
            #install_python_language_server
	    set_repos
            install_lua_language_server
            move_luamake_alias
            print_warning "Be sure to install your plugins the first time you run Neovim by executing:\n:PlugInstall --sync"
            exit 0
            ;;
        -u|--uninstall)
	    remove_luamake_alias
	    remove_lua_language_server
            exit 0
            ;;
        *)
            echo "Invalid option."
            exit 1
            ;;
     esac
done

exit 0
