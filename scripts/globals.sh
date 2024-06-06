#!/bin/bash
# globals.sh - source this file for common globals across all scripts

# Orient to location of this script using this crazy, well-known command
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Set the location to the top of this repo
top_dir=`dirname ${script_dir}`

# Get a timestamp for replacing existing files
timestamp=$(date +"%Y%m%d%H%M")
