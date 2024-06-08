#!/bin/bash
#
# neovim_addtions.sh - installs and configures additions for neovim beyond that
# provided by Doc Mike's vimfiles.

usage()
{
cat << EOF
Usage: $0 [options]

# Installs and configures additions for neovim beyond that provided by Doc 
# Mike's vimfiles.

OPTIONS:
-h, --help          This message.
-sr, --set-repos    Interactively change the location of the Git repo for 
                    lua-language-server.

EOF
}

source globals.sh

# Set default repos
lua_language_server_repo=https://github.com/sumneko/lua-language-server

set_repos()
{
read -rp "Enter new lua-language-server repo location: " newrepo 
lua_language_server_repo=${newrepo}

echo ""
}

# TODO: options to set repos
install_python_neovim()
{
echo -e "Installing neovim package to native Python 3, locally.\n"  
python3 -m pip install neovim
}

install_python_language_server()
{
echo -e "Installing python-language-server package to native Python 3, locally.\n"  
python3 -m pip install python-language-server[all]
}

install_lua_language_server()
{
# Clone vimfiles repo under the linux-config
lua_language_server_path="$top_dir/repos/lua-language-server"
if [ -d "$lua_language_server_path" ]; then
    echo -e "$lua_language_server_path already exists, skipping clone.\n"
else
    echo -e "Cloning ${lua_language_server_repo} to ${lua_language_server_path}.\n"
    git clone "$lua_language_server_repo" "$lua_language_server_path"
fi

# Build and install the server
echo -e "Starting build of lua-language-server."
cd "$lua_language_server_path" || exit 1 
git submodule update --init --recursive
cd 3rd/luamake || exit 1
compile/install.sh
cd "$lua_language_server_path" || exit 1 
./3rd/luamake/luamake rebuild
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

install_python_neovim
install_python_language_server
install_lua_language_server
exit 0
