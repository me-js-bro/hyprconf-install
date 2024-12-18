#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Js Bro ( https://github.com/me-js-bro ) ####

# exit the script if there is any error
# set -e

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
   __ __              __             __
  / // /_ _____  ____/ /__ ____  ___/ /
 / _  / // / _ \/ __/ / _ `/ _ \/ _  / 
/_//_/\_, / .__/_/ /_/\_,_/_//_/\_,_/  
     /___/_/                           
'
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

parent_dir="$(dirname "$dir")"
__hypr_cache="$parent_dir/.cache/2-hyprland"

if [[ -f "$__hypr_cache" ]]; then
    source "$__hypr_cache"

    errors=$(grep "error" "$__hypr_cache")
    if [[ -z "$errors" ]]; then
        printf "${note}\n;; No need to run this script again\n"
        exit 0

    elif [[ -n "$errors" ]]; then
        error_pkgs=($(grep "error" "$__hypr_cache" | awk {'print $1'}))
            for __erros in "${error_pkgs[@]}"; do
                install_package "$__erros"
            done
    fi

elif [[ ! -f "$__hypr_cache" ]]; then
    touch "$__hypr_cache"
fi

source "$parent_dir/interaction_fn.sh"

# log directory
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
    hypridle
    hyprcursor
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

# Instlling main packages...
printf "${action}\n==> Installing main packages.\n"
# Install from official repo
for hypr_pkgs in "${hypr_packages[@]}"; do
    install_package "$hypr_pkgs"
    if sudo pacman -Qe "$hypr_pkgs" &>/dev/null; then
        echo "[ DONE ] - $hypr_pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &>/dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $hypr_pkgs!\n" 2>&1 | tee -a "$log" &>/dev/null

        if ! grep -q "$hypr_pkgs = 'error'" "$__hypr_cache"; then
            echo "$hypr_pkgs = 'error'" >> "$__hypr_cache" &> /dev/null
        fi
    fi
done

sleep 1 && clear
