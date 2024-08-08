#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Js Bro ( https://github.com/me-js-bro ) ####

# exit the script if there is any error
set -e

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
     ____                                                  
    | __ )  _ __  ___ __      __ ___   ___  _ __           
    |  _ \ | '__|/ _ \\ \ /\ / // __| / _ \| '__|          
    | |_) || |  | (_) |\ V  V / \__ \|  __/| |     _  _  _ 
    |____/ |_|   \___/  \_/\_/  |___/ \___||_|    (_)(_)(_)
                                                    
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
log="$log_dir/browser-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# finding the aur helper
aur_helper=$(command -v yay || command -v paru)

# asking which browser wants to install
printf "Which browser would you like to install?\n1) ${orange}Brave-Browser.${end} \n2) ${cyan}Chromium.${end}\n"
read -r -p "$(echo -e '\e[1;32mSelect: \e[0m')" browser
printf " \n"

if [[ "$browser" == "1" ]]; then
    "$aur_helper" -S --noconfirm brave-bin 2>&1 | tee -a "$log"
elif [[ "$browser" == "2" ]]; then
    "$aur_helper" -S --noconfirm ungoogled-chromium-bin 2>&1 | tee -a "$log"
else
    printf "${attention} - A browser installation is important to open some web-applications\n"
    exit 1
fi
