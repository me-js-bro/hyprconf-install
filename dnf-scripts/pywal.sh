#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Shell Ninja ( https://github.com/shell-ninja ) ####

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"


###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# log directory
parent_dir="$(dirname "$dir")"
log_dir="$parent_dir/Logs"
log="$log_dir/pywal-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"


msg act "Installing pywal.."
sudo pip install pywal 2>&1 | tee -a "$log" &> /dev/null

sleep 1

if [ -n "$(command -v wal)" ]; then
    msg dn "pywal was installed successfully!"
else
    msg err "Couls not install pywal."
fi


sleep 1 && clear
