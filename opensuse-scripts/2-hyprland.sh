#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Shell Ninja ( https://github.com/shell-ninja ) ####

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"

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
printf " \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

# log directory
log_dir="$parent_dir/Logs"
log="$log_dir/hyprland-$(date +%d-%m-%y).log"

# skip installed cache
cache_dir="$parent_dir/.cache"
installed_cache="$cache_dir/installed_packages"

mkdir -p "$log_dir"
touch "$log"

hypr_pkgs=(
    hyprland
    hyprpaper
    hyprcursor
    hyprland-protocols-devel
    wayland-protocols-devel
    hyprutils-devel
    hyprwayland-scanner
)

hypr_others=(
  python311-aiofiles
  python312-pip
  python312-pipx
  python-base
  hyprlock
  hypridle
)

# checking already installed packages 
for skipable in "${hypr_pkgs[@]}"; do
    skip_installed "$skipable"
done

to_install=($(printf "%s\n" "${hypr_pkgs[@]}" | grep -vxFf "$installed_cache"))

printf "\n\n"

# Hyprland
for packages in "${to_install[@]}"; do
  install_package "$packages"

    if sudo zypper se -i "$packages" &> /dev/null ; then
        echo "[ DONE ] - $packages was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Could not install $packages..." 2>&1 | tee -a "$log" &> /dev/null
    fi
done

for others in "${hypr_others[@]}"; do
  install_package_opi "$others"

    if sudo zypper se -i "$others" &> /dev/null ; then
        echo "[ DONE ] - $others was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Could not install $others..." 2>&1 | tee -a "$log" &> /dev/null
    fi
done

# Check if the file exists and delete it
pypr="/usr/local/bin/pypr"
if [ -f "$pypr" ]; then
    sudo rm "$pypr"
fi

# Hyprland Plugins
# pyprland https://github.com/hyprland-community/pyprland installing using python
msg act "Installing pyprland..."

curl https://raw.githubusercontent.com/hyprland-community/pyprland/main/scripts/get-pypr | sh  2>&1 | tee -a "$LOG"

sudo pip install pyprland --break-system-packages 2>&1 | tee -a "$LOG" 

sleep 1 && clear
