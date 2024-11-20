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
   ____   _               _                 _    _               
  | __ ) | | _   _   ___ | |_  ___    ___  | |_ | |__            
  |  _ \ | || | | | / _ \| __|/ _ \  / _ \ | __|| '_ \           
  | |_) || || |_| ||  __/| |_| (_) || (_) || |_ | | | |  _  _  _ 
  |____/ |_| \__,_| \___| \__|\___/  \___/  \__||_| |_| (_)(_)(_)
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
parent_dir="$(dirname "$dir")"
cache_dir="$parent_dir/.cache"
distro_cache="$cache_dir/distro"
source "$distro_cache"

# install script dir
source "$parent_dir/${distro}-scripts/1-global_script.sh"

# log dir
log_dir="$parent_dir/Logs"
log="$log_dir/bluetooth-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

if [[ "$distro" == "arch" ]]; then
  bluetooth=(
    bluez
    bluez-utils
    blueman
  )
elif [[ "$distro" == "fedora" ]]; then
  bluetooth=(
    bluez
    bluez-tools
    blueman
    python3-cairo
  )
elif [[ "$distro" == "opensuse" ]]; then
  bluetooth=(
    bluez
    blueman
  )

# Bluetooth

printf "${action} Installing Bluetooth Packages...\n"
 for bluetooth_pkgs in "${bluetooth[@]}"; do
   install_package "$bluetooth_pkgs"
  done

printf "${note} - Activating Bluetooth Services...\n"
sudo systemctl enable --now bluetooth.service 2>&1 | tee -a "$log"

clear