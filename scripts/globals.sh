#!/bin/bash
# globals.sh - source this file for common globals across all scripts

# Orient to location of this script using this crazy, well-known command
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Set the location to the top of this repo
top_dir=`dirname ${script_dir}`

# Get a timestamp for replacing existing files
timestamp=$(date +"%Y%m%d%H%M")

# Provide ANSI colors
# Usage example:
# print_info "This is good info!"

RED='\033[1;31m'
GRN='\033[1;32m'
YEL='\033[1;33m'
CYN='\e[36m'
NC='\033[0m'  # no color

print_info() {
    echo -e ${GRN}${1}${NC}
}

print_warning() {
    echo -e ${YEL}${1}${NC}
}

print_error() {
    echo -e ${RED}${1}${NC}
}

print_exec_command() {
    echo -e "${CYN}+ ${1}${NC}"
    ${1}
}
