#!/bin/bash
usage()
{
cat << EOF
Usage: $0 [options]

Add the Git configuration name and email address to the existing home/.gitconfig
file. Also, offer to disable HTTP SSL verify.

OPTIONS:
-h, --help          This message.

EOF
}

source globals.sh

# Set the location of the local .gitconfig
git_config=${top_dir}/home/.gitconfig

# Set the user's name in the .gitconfig
set_username()
{
read -rp "Enter desired name presented in git commits: " ans
command="git config --file=${git_config} user.name \"${ans}\""
print_exec_command "${command}"
}

# Set the user's email in the .gitconfig
set_email()
{
read -rp "Enter desired email presented in git commits: " ans
command="git config --file=${git_config} user.email \"${ans}\""
print_exec_command "${command}"
}

#  Offer to set the sslVerify to false in the .gitconfig
offer_sslVerify_false()
{
read -rp "Do you want to change the HTTP SSL verify to false? (y/N)" ans
if [[ "${ans}" == [yY]  ]]; then
    command="git config --file=${git_config} http.sslVerify \"false\""
    print_exec_command "${command}"
fi
}

# Check for max num of options
maxnumargs=1
if [ "$#" -gt ${maxnumargs} ]; then
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
            exit 1
            ;;
     esac
done

set_username
set_email
offer_sslVerify_false
print_info "Done!"
exit 0
