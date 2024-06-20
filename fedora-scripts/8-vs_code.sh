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

# finding the presend directory and log file
present_dir=`pwd`
# log directory
log_dir="$present_dir/Logs"
log="$log_dir"/vs-code.log
mkdir -p "$log_dir"
if [[ ! -f "$log" ]]; then
    touch "$log"
fi

# install script dir
scripts_dir=`dirname "$(realpath "$0")"`
source $scripts_dir/1-global_script.sh

# checking if vs code is installed
if sudo dnf list installed code &>> /dev/null; then
    printf "${done} - Visual Studio Code is already installed, proceeding to next step\n"
# insalling vs code
else
    printf "${attention} - Processing to install Visual Studio Code... \n"
    sleep 1

    # adding vs code repo
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc 2>&1 | tee -a "$log" &>> /dev/null
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' 2>&1 | tee -a "$log" &>> /dev/null

    printf "${action} - Installing Visual Studio Code. Please wait...\n"
    sudo dnf install -y code 2>&1 | tee -a "$log"

    if sudo dnf list installed code &>> /dev/null; then
        printf "${done} - Visual Studio Code was installed successfully..\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    else
        printf "${error} - Could not installed Visual Studio Code. Please check the $log file Maybe you need to install it manually.\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    fi
fi

common_scripts="$present_dir/common"
"$common_scripts/vs_code_theme.sh"

clear