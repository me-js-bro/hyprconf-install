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

# finding the presend directory and log file
present_dir=`pwd`
cache_dir="$present_dir/.cache"
distro_cache="$cache_dir/distro"

source "$distro_cache"

# log directory
log_dir="$present_dir/Logs"
log="$log_dir"/bluetooth.log
mkdir -p "$log_dir"
if [[ ! -f "$log" ]]; then
    touch "$log"
fi

# install script dir
scripts_dir="$present_dir/${distro}-scripts"
source $scripts_dir/1-global_script.sh

echo "$scripts_dir"

bluetooth=(
bluez
bluez-tools
blueman
python3-cairo
)

# Bluetooth

printf "${action} Installing Bluetooth Packages...\n"
 for bluetooth_pkgs in "${bluetooth[@]}"; do
   install_package "$bluetooth_pkgs" "$log"
  done

printf "${note} - Activating Bluetooth Services...\n"
sudo systemctl enable --now bluetooth.service 2>&1 | tee -a "$log"

clear