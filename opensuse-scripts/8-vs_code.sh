#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Js Bro ( https://github.com/me-js-bro ) ####

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\x1b[38;5;214m"
end="\e[1;0m"

# initial texts
attention="[${orange} ATTENTION ${end}]"
action="[${green} ACTION ${end}]"
note="[${magenta} NOTE ${end}]"
done="[${cyan} DONE ${end}]"
ask="[${orange} QUESTION ${end}]"
error="[${red} ERROR ${end}]"

display_text() {
    cat << "EOF"
    __     __          ____            _                 
    \ \   / /___      / ___| ___    __| |  ___           
     \ \ / // __|    | |    / _ \  / _` | / _ \          
      \ V / \__ \ _  | |___| (_) || (_| ||  __/  _  _  _ 
       \_/  |___/(_)  \____|\___/  \__,_| \___| (_)(_)(_)
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"


# log directory
parent_dir="$(dirname "$dir")"
log_dir="$parent_dir/Logs"
log="$log_dir/vs_code-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

printf "${attention} - Processing to install Visual Studio Code... \n"
sleep 1

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc 2>&1 | tee -a "$log"
sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode 2>&1 | tee -a "$log"
sudo zypper refresh 2>&1 | tee -a "$log"
sudo zypper in -y code 2>&1 | tee -a "$log"

common_scripts="$parent_dir/common"
"$common_scripts/vs_code_theme.sh"

clear