#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Js Bro ( https://github.com/me-js-bro ) ####

# exit the script if there is any error
set -e

# Color definition
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[38;5;214m"
end="\e[1;0m"

# Initial texts
attention="[${orange} ATTENTION ${end}]"
action="[${green} ACTION ${end}]"
note="[${magenta} NOTE ${end}]"
done="[${cyan} DONE ${end}]"
ask="[${orange} QUESTION ${end}]"
error="[${red} ERROR ${end}]"

display_text() {
    cat << "EOF"
        _                  _   _        _                              
       / \   _   _  _ __  | | | |  ___ | | _ __    ___  _ __           
      / _ \ | | | || '__| | |_| | / _ \| || '_ \  / _ \| '__|          
     / ___ \| |_| || |    |  _  ||  __/| || |_) ||  __/| |     _  _  _ 
    /_/   \_\\__,_||_|    |_| |_| \___||_|| .__/  \___||_|    (_)(_)(_)
                                          |_|                                
   
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# Finding the present directory and log file


# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# log directory
parent_dir="$(dirname "$dir")"
cache_file="$parent_dir/.cache/user-cache"

log_dir="$parent_dir/Logs"
log="$log_dir/aur_helper-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# Check for existing AUR helpers
aur_helper=$(command -v yay || command -v paru)

if [[ -f "$cache_file" ]]; then
    source "$cache_file"
fi

# install git before installing the aur helper.
if ! pacman -Qe git &> /dev/null; then
    printf "${orange}Git was not installed, installing it...${end}\n"
    sudo pacman -S --noconfirm git 2>&1 | tee -a "$log" &> /dev/null
    printf "${cyan}Git was installed successfully!${end}\n"
fi

if [[ -z "$aur_helper" ]]; then
    printf "${attention} - Which AUR helper would you like to install? It is necessary...\n1) paru \n2) yay \n"
    read -r -p "$(echo -e '\e[1;32mSelect: \e[0m')" aur

    sudo rm -rf /var/lib/pacman/db.lck

    if [[ "$aur" == "1" ]]; then
        echo "aur='1'" >> "$cache_file"
        git clone "https://aur.archlinux.org/paru.git"
        cd paru
        makepkg -si --noconfirm
        sleep 1
        cd "$parent_dir"
        sudo rm -rf paru
        
    elif [[ "$aur" == "2" ]]; then
        echo "aur='2'" >> "$cache_file"
        git clone "https://aur.archlinux.org/yay.git"
        cd yay
        makepkg -si --noconfirm
        sleep 1
        cd "$parent_dir"
        sudo rm -rf yay
    else
        printf "${note} - Invalid selection. Please re-execute the script and choose between [1/2]. Exiting the script.\n"
        exit 1
    fi
else
    printf "${attention} - AUR helper ($aur_helper) already installed. No need to choose again.\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

if [[ -n "$aur_helper" ]]; then
    printf "${done} - $aur_helper was installed successfully!\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
else
    printf "${error} - ${red}$aur_helper could not be installed. Maybe there was a network isseu. Please check the '$log' file. (╥﹏╥)${end}\n"
    exit 1
fi