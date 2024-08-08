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
     _____              _                  
    |  ___|___   _ __  | |_  ___           
    | |_  / _ \ | '_ \ | __|/ __|          
    |  _|| (_) || | | || |_ \__ \  _  _  _ 
    |_|   \___/ |_| |_| \__||___/ (_)(_)(_)
                                      
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
log="$log_dir/fonts-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# necessary fonts [ new installable fonts should be added here ]
fonts=(
    ttf-font-awesome
    ttf-cascadia-code
    ttf-jetbrains-mono-nerd
    ttf-meslo-nerd
    noto-fonts 
    noto-fonts-emoji
)

printf "${action} - Now installing some necessary fonts...\n" && sleep 1

for font_pkgs in "${fonts[@]}"; do
    install_package "$font_pkgs"
    if sudo pacman -Qe "$font_pkgs" &> /dev/null; then
        echo "[ DONE ] - $font_pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $font_pkgs!\n" 2>&1 | tee -a "$log" &> /dev/null
    fi
done
