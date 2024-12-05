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
    gum style \
        --border rounded \
        --align center \
        --width 40 \
        --margin "1" \
        --padding "1" \
'
  ____  __  __             
 / __ \/ /_/ /  ___ _______
/ /_/ / __/ _ \/ -_) __(_-<
\____/\__/_//_/\__/_/ /___/
                             
'
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# log directory
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

log_dir="$parent_dir/Logs"
log="$log_dir/others-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# any other packages will be installed from here
other_packages=(
    btop
    curl
    fastfetch
    ffmpeg
    gnome-disk-utility
    ibus
    imagemagick
    jq
    kvantum
    lxappearance
    network-manager-applet
    networkmanager
    ntfs-3g
    nvtop
    os-prober
    pacman-contrib
    pamixer
    pavucontrol
    python-pillow
    python-pywal
    ranger
    wget
    yad
)

aur_packages=(
    grimblast-git
    hyprsunset
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

printf "${action}\n==> Installing necessary packages"
for other_pkgs in "${other_packages[@]}"; do
    install_package "$other_pkgs"
    if sudo pacman -Qe "$other_pkgs" &> /dev/null; then
        echo "[ DONE ] - $other_pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $other_pkgs!\n" 2>&1 | tee -a "$log" &> /dev/null
    fi
done

sleep 1 && clear

# Installing from the AUR Helper
for aur_pkgs in "${aur_packages[@]}"; do
    install_from_aur "$aur_pkgs"
    if sudo "$aur_helper" -Qe "$aur_pkgs" &> /dev/null; then
        echo "[ DONE ] - $aur_pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $aur_pkgs!\n" 2>&1 | tee -a "$log" &> /dev/null
    fi
done

sleep 1 && clear

# installing thunar file manager 
for file_man in "${thunar[@]}"; do
    install_package "$file_man"
    if sudo pacman -Qe "$file_man" &> /dev/null; then
        echo "[ DONE ] - $file_man was installed successfully!\n" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $file_man!\n" 2>&1 | tee -a "$log" &> /dev/null
    fi
done

sleep 1 && clear