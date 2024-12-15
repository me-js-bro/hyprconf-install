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

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# log directory
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

log_dir="$parent_dir/Logs"
log="$log_dir/xdg_dp-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

xdg=(
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
)

# XDG-DESKTOP-PORTAL-HYPRLAND
for xdgs in "${xdg[@]}"; do
    install_package "$xdgs" "$log"
done

printf "${action}\n==> Checking for other XDG-Desktop-Portal-Implementations.\n"

printf "${ask}\n?? Would you like to remove other XDG-Desktop-Portal-Implementations?\n"
gum configm "Choose..." \
    --affirmative "Remove" \
    --negative "Don't remove"

if [[ $? -eq 0 ]]; then
    # Clean out other portals
    printf "${action}\n==> Clearing other xdg-desktop-portal implementations.\n"
    # Check if packages are installed and uninstall if present
    if pacman -Qs xdg-desktop-portal-wlr >/dev/null; then
        echo "Removing xdg-desktop-portal-wlr..."
        sudo pacman -R --noconfirm xdg-desktop-portal-wlr 2>&1 | tee -a "$log"
    fi

    if pacman -Qs xdg-desktop-portal-lxqt >/dev/null; then
        echo "Removing xdg-desktop-portal-lxqt..."
        sudo pacman -R --noconfirm xdg-desktop-portal-lxqt 2>&1 | tee -a "$log"
    fi
else
    echo "no other XDG-implementations will be removed." >>"$log"
fi
