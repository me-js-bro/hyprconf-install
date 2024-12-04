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
  __  __     _          __       ____
 / / / /__  (_)__  ___ / /____ _/ / /
/ /_/ / _ \/ / _ \(_-</ __/ _ `/ / / 
\____/_//_/_/_//_/___/\__/\_,_/_/_/    
                                    
'
}

clear && display_text
printf " \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

# log
log_dir="$parent_dir/Logs"
log="$log_dir/uninstall-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

removable=(
    wofi
)

for pkg in "${removable[@]}"; do
    if sudo pacman -Qe "$pkg" &> /dev/null; then
        printf "${action}\n==> $pkg was found, removing it\n"
        sudo pacman -Rns --noconfirm "$pkg" 2>&1 | tee -a "$log"

        if ! sudo pacman -Qe "$pkg" &> /dev/null; then
            fn_done "$pkg was removed successfully!"
        else
            fn_error "Could not remove $pkg (╥﹏╥)"
        fi
    fi
done