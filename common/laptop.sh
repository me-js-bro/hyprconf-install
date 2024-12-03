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
   __             __          
  / /  ___ ____  / /____  ___ 
 / /__/ _ `/ _ \/ __/ _ \/ _ \
/____/\_,_/ .__/\__/\___/ .__/
         /_/           /_/    
                               
'
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

cache_dir="$parent_dir/.cache"
distro_cache="$cache_dir/distro"
source "$distro_cache"

# install script dir
source "$parent_dir/${distro}-scripts/1-global_script.sh"

# log dir
log_dir="$parent_dir/Logs"
log="$log_dir/laptop-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

packages=(
    brightnessctl
    wlroots
)

fn_action "This system is a Laptop. Proceeding with some configuration."

# Install necessary packages
for pkgs in "${packages[@]}"; do
    install_package "$pkgs" || { printf "${error} - Could not install $pkgs, exiting. (╥﹏╥)\n"; exit 1; } 2>&1 | tee -a "$log"
done
