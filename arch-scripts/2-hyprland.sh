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
     _   _                      _                    _           
    | | | | _   _  _ __   _ __ | |  __ _  _ __    __| |          
    | |_| || | | || '_ \ | '__|| | / _` || '_ \  / _` |          
    |  _  || |_| || |_) || |   | || (_| || | | || (_| |  _  _  _ 
    |_| |_| \__, || .__/ |_|   |_| \__,_||_| |_| \__,_| (_)(_)(_)
            |___/ |_|                                            
   
EOF
}

aur_text() {
    cat << "EOF"
        _                  ____               _                                     
       / \   _   _  _ __  |  _ \  __ _   ___ | | __ __ _   __ _   ___  ___          
      / _ \ | | | || '__| | |_) |/ _` | / __|| |/ // _` | / _` | / _ \/ __|         
     / ___ \| |_| || |    |  __/| (_| || (__ |   <| (_| || (_| ||  __/\__ \ _  _  _ 
    /_/   \_\\__,_||_|    |_|    \__,_| \___||_|\_\\__,_| \__, | \___||___/(_)(_)(_)
                                                          |___/                     
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
log="$log_dir/hyprland-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

aur_helper=$(command -v yay || command -v paru) # find the aur helper

# Main Hyprland packages
hypr_packages=(
cliphist
eog
hyprland
hyprlock
hyprpaper
kitty
nwg-look
polkit-gnome
qt5ct
qt5-svg
qt6ct
qt6-svg
qt5-graphicaleffects
qt5-quickcontrols2
rofi-wayland
swappy
swaync
swww
waybar
wl-clipboard
xdg-desktop-portal-hyprland
)

aur_packages=(
grimblast-git
)

# thunar file manager
thunar=(
ffmpegthumbnailer
file-roller
gvfs
gvfs-mtp 
thunar 
thunar-volman 
tumbler 
thunar-archive-plugin
)


# Instlling main packages...
printf "${note} - Installing main packages, this may take a while...\n" && sleep 1
# Install from official repo
for hypr_pkgs in "${hypr_packages[@]}"; do
    install_package "$hypr_pkgs"
    if sudo pacman -Qe "$hypr_pkgs" &> /dev/null; then
        echo "[ DONE ] - $hypr_pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $hypr_pkgs!\n" 2>&1 | tee -a "$log" &> /dev/null
    fi
done

sleep 1

clear && aur_text

printf "${action} - Now installing some packages from the aur helper...\n" && sleep 1
# Installing from the AUR Helper
for aur_pkgs in "${aur_packages[@]}"; do
    install_from_aur "$aur_pkgs"
    if sudo "$aur_helper" -Qe "$aur_pkgs" &> /dev/null; then
        echo "[ DONE ] - $aur_pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $aur_pkgs!\n" 2>&1 | tee -a "$log" &> /dev/null
    fi
done

# installing thunar file manager
printf "${action} - Installing Thunar file manager. \n"    
for file_man in "${thunar[@]}"; do
    install_package "$file_man"
    if sudo pacman -Qe "$file_man" &> /dev/null; then
        echo "[ DONE ] - $file_man was installed successfully!\n" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $file_man!\n" 2>&1 | tee -a "$log" &> /dev/null
    fi
done

clear