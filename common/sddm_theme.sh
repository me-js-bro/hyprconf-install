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
    gum style \
        --border rounded \
        --align center \
        --width 60 \
        --margin "1" \
        --padding "1" \
'
   _______  ___  __  ___  ________                
  / __/ _ \/ _ \/  |/  / /_  __/ /  ___ __ _  ___ 
 _\ \/ // / // / /|_/ /   / / / _ \/ -_)  ; \/ -_)
/___/____/____/_/  /_/   /_/ /_//_/\__/_/_/_/\__/ 
                                                   
'
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
source "$parent_dir/interaction_fn.sh"

log_dir="$parent_dir/Logs"
log="$log_dir/sddm_theme-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# Install THEME
theme="$parent_dir/assets/minimal_sddm.tar.gz"
theme_dir=/usr/share/sddm/themes

# creating sddm theme dir
if [ ! -d "$theme_dir" ]; then
    printf "${action}\n==> Sddm theme dir was not found, creatint it.\n"
    sudo mkdir -p "$theme_dir"
fi

# Set up SDDM
printf "${action}\n==> Setting up the Login Screen.\n"
sddm_conf_dir=/etc/sddm.conf.d
[ ! -d "$sddm_conf_dir" ] && { printf "$sddm_conf_dir not found, creating...\n"; sudo mkdir -p "$sddm_conf_dir"; }


sudo tar -xf "$theme" -C "$theme_dir"
echo -e "[Theme]\nCurrent=minimal_sddm" | sudo tee "$sddm_conf_dir/theme.conf.user" &> /dev/null

if [ -d "$theme_dir/minimal_sddm" ]; then
    fn_done "Sddm theme was installed successfully!"
fi