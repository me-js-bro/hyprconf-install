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

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# log directory
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

# skip installed cache
cache_dir="$parent_dir/.cache"
installed_cache="$cache_dir/installed_packages"

# log dir
log_dir="$parent_dir/Logs"
log="$log_dir/xdg_dp-$(date +%d-%m-%y).log"

mkdir -p "$log_dir"
touch "$log"

xdg=(
xdg-desktop-portal-hyprland
xdg-desktop-portal-gtk
)


# checking already installed packages 
for skipable in "${xdg[@]}"; do
    skip_installed "$skipable"
done

to_install=($(printf "%s\n" "${xdg[@]}" | grep -vxFf "$installed_cache"))

printf "\n\n"

# XDG-DESKTOP-PORTALS
for xdgs in "${to_install[@]}"; do
  install_package_no_recommands "$xdgs" 2>&1 | tee -a "$log"
done

msg att "Checking for other XDG-Desktop-Portal-Implementations..."

fn_ask "Would you like to remove other XDG-Desktop-Portal-Implementations?" "Yes!" "No!"


if [[ $? -eq 0 ]]; then
    # Clean out other portals
    msg act "Clearing any other xdg-desktop-portal implementations..."
    #Check if packages are installed and uninstall if present
    if sudo zypper se -i xdg-desktop-portal-wlr &> /dev/null; then
      printf "Removing xdg-desktop-portal-wlr...\n"
      sudo zypper rm -y xdg-desktop-portal-wlr 2>&1 | tee -a "$log"
    fi

    if sudo zypper se -i xdg-desktop-portal-lxqt &> /dev/null; then
      printf "Removing xdg-desktop-portal-lxqt...\n"
      sudo zypper rm -y xdg-desktop-portal-lxqt 2>&1 | tee -a "$log"
    fi

else
    msg skp "No other XDG-implementations will be removed.\n" 2>&1 | tee -a "$log"
fi

sleep 1 && clear
