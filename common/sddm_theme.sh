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
orange="\e[1;38;5;214m"
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
  ____   ____   ____   __  __   _____  _                                     
 / ___| |  _ \ |  _ \ |  \/  | |_   _|| |__    ___  _ __ ___    ___          
 \___ \ | | | || | | || |\/| |   | |  | '_ \  / _ \| '_ ` _ \  / _ \         
  ___) || |_| || |_| || |  | |   | |  | | | ||  __/| | | | | ||  __/ _  _  _ 
 |____/ |____/ |____/ |_|  |_|   |_|  |_| |_| \___||_| |_| |_| \___|(_)(_)(_)
                                                      
EOF
}

clear && display_text
printf " \n \n"

printf " \n"

###------ Startup ------###

# finding the presend directory and log file
# install script dir
dir="$(dirname "$(realpath "$0")")"

# log directory
parent_dir="$(dirname "$dir")"
log_dir="$parent_dir/Logs"
log="$log_dir/sddm_theme-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# Install THEME
theme="$parent_dir/assets/minimal_sddm.tar.gz"
theme_dir=/usr/share/sddm/themes

# creating sddm theme dir
if [ ! -d "$theme_dir" ]; then
    printf "${attention} - Sddm theme dir was not found, creatint it.\n"
    sudo mkdir -p "$theme_dir"
fi

# Set up SDDM
printf "${action} - Setting up the login screen."
sddm_conf_dir=/etc/sddm.conf.d
[ ! -d "$sddm_conf_dir" ] && { printf "$sddm_conf_dir not found, creating...\n"; sudo mkdir -p "$sddm_conf_dir"; }


sudo tar -xf "$theme" -C "$theme_dir"
printf "[Theme]\nCurrent=minimal_sddm\n" | sudo tee "$sddm_conf_dir/theme.conf.user"

if [ -d "$theme_dir/minimal_sddm" ]; then
    printf "${done} - Sddm theme was installed successfully!\n"
fi