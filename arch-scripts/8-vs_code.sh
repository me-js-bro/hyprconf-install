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

aur_helper=$(command -v yay || command -v paru) # find the aur helper

vs_code=(
    visual-studio-code-bin
)

# installing vs code
for code in "${vs_code[@]}"; do
    install_from_aur "$code"
    if sudo "$aur_helper" -Qs "$code" &>> /dev/null; then
        echo "[ DONE ] - $code was installed successfully!\n" 2>&1 | tee -a "$log" &>> /dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $code!\n" 2>&1 | tee -a "$log" &>> /dev/null
    fi
done

# updating vs code themes
common_scripts="$parent_dir/common"
"$common_scripts/vs_code_theme.sh"

# clear