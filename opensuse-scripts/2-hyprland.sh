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
     _   _                      _                    _           
    | | | | _   _  _ __   _ __ | |  __ _  _ __    __| |          
    | |_| || | | || '_ \ | '__|| | / _` || '_ \  / _` |          
    |  _  || |_| || |_) || |   | || (_| || | | || (_| |  _  _  _ 
    |_| |_| \__, || .__/ |_|   |_| \__,_||_| |_| \__,_| (_)(_)(_)
            |___/ |_|                                            
   
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

hypr_pkgs=(
    hyprland
    hyprlock
    hyprpaper
    hypridle
    hyprcursor
    hyprland-protocols-devel
    wayland-protocols-devel
    hyprutils-devel
    hyprwayland-scanner
)

# Hyprland
printf "${action} - Installing Hyprland packages...\n"
for packages in "${hypr_pkgs[@]}"; do
  install_package "$packages"
    if sudo zypper se -i "$packages" &> /dev/null ; then
        echo "[ DONE ] - $packages was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Could not install $packages..." 2>&1 | tee -a "$log" &> /dev/null
    fi
done

sleep 1

printf "${action} - Installing Hyprsunset...\n"

if ! sudo zypper se -i git &> /dev/null; then
    install_package git
fi

if ! sudo zypper se -i cmake &> /dev/null; then
    install_package cmake
fi


if git clone --depth=1 https://github.com/hyprwm/hyprsunset "$parent_dir/.cache/hyprsunset"; then
    cd "$parent_dir/.cache/hyprsunset"
    mkdir build && cd build
    cmake ..
    sudo make install

    sleep 1

    if command -v hyprsunset &> /dev/null; then
        printf "${done} - Hyprsunset was installed successfully!\n" 2>&1 | tee -a "$log"
    else
        printf "${error} - Sorry, could not install Hyprsunset. :(\n" 2>&1 | tee -a "$log"
    fi
fi

sleep 1 && clear