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

vs_code_dir=~/.config/Code
vs_code_plugins_dir=~/.vscode

    # backing up vs code directory "Code"
    if [ -d "$vs_code_dir" ]; then
        printf "${action} - Backing up .config/Code directory...\n"
        mv "$vs_code_dir" "$vs_code_dir"-${USER}
    fi

    # backing up vs code directory "Plugins"
    if [ -d "$vs_code_plugins_dir" ]; then
        printf "${action} - Backing up directory...\n"
        mv "$vs_code_plugins_dir" "$vs_code_plugins_dir"-${USER}
    fi
    
# copying vs code themes and plugins dir
printf "${action} - Copying Code directory..."
assets_dir="$present_dir"/assets

cp -r "$assets_dir"/Code ~/.config/
cp -r "$assets_dir"/.vscode ~/

sleep 1

printf "${done} - Vs Code themes and some plugins have been copied\n"