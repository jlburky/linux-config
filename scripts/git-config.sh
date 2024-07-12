#!/bin/bash

usage()
{
cat << EOF
Usage: $0 COMMAND

Set the user's Git configuration file and add the local Git configurations like
the name and email address to a home/.gitconfig_local file. 

COMMANDS:
-h, --help          This message.
-i, --install       Install git configs.
-u, --uninstall     Uninstall all configs executed by this script.

EOF
}

source globals.sh

# Set the location of the .gitconfig_local
git_config_local=${top_dir}/stow/git/.gitconfig_local

# Set the user's name in the .gitconfig
set_username()
{
read -rp "Enter desired name presented in git commits: " ans
command="git config --file=${git_config_local} user.name \"${ans}\""
print_exec_command "${command}"
}

# Set the user's email in the .gitconfig
set_email()
{
read -rp "Enter desired email presented in git commits: " ans
command="git config --file=${git_config_local} user.email \"${ans}\""
print_exec_command "${command}"
}

#  Offer to set the sslVerify to false in the .gitconfig
offer_sslVerify_false()
{
read -rp "Do you want to change the HTTP SSL verify to false? (y/N)" ans
if [[ "${ans}" == [yY]  ]]; then
    command="git config --file=${git_config_local} http.sslVerify \"false\""
    print_exec_command "${command}"
else
    command="git config --file=${git_config_local} http.sslVerify \"true\""
    print_exec_command "${command}"
fi
}

remove_git_local()
{
command="rm -f ${git_config_local}"
print_exec_command "${command}"

}

# Stow the git package
stow_git()
{
command="cd ${top_dir}/stow"
print_exec_command "$command"

command="../scripts/stow-home.sh --install git"
print_exec_command "$command"

cd - > /dev/null
}

# Unstow the git package
unstow_git()
{
command="cd ${top_dir}/stow"
print_exec_command "$command"

command="../scripts/stow-home.sh --uninstall git"
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
            set_username
            set_email
            offer_sslVerify_false
            stow_git
            exit 0
            ;;
        -u|--uninstall)
            unstow_git
            remove_git_local
            exit 0
            ;;
        *)
            echo "Invalid option."
            exit 1
            ;;
     esac
done

exit 0
