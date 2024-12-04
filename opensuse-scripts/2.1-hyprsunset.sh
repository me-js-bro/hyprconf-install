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
   __ __                                    __ 
  / // /_ _____  _______ __ _____  ___ ___ / /_
 / _  / // / _ \/ __(_-</ // / _ \(_-</ -_) __/
/_//_/\_, / .__/_/ /___/\_,_/_//_/___/\__/\__/ 
     /___/_/                                    
'
}

clear && display_text
printf " \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# log directory
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

log_dir="$parent_dir/Logs"
log="$log_dir/hyprsunset-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

printf "${action}\n==>  Installing Hyprsunset.\n"

if ! sudo zypper se -i git &> /dev/null; then
    install_package git
fi

if ! sudo zypper se -i cmake &> /dev/null; then
    install_package cmake
fi

if ! sudo zypper se -i make &> /dev/null; then
    install_package make
fi

if git clone --depth=1 https://github.com/hyprwm/hyprsunset "$parent_dir/.cache/hyprsunset"; then
    cd "$parent_dir/.cache/hyprsunset"
    mkdir build
    cd build
    cmake .. &> /dev/null
    sleep 1
    sudo make install &> /dev/null

    sleep 1

    if command -v hyprsunset &> /dev/null; then
        fn_done "Hyprsunset was installed successfully!"
        echo "[ DONE ] - Hyprsunset was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
    else
        fn_error "Sorry, could not install Hyprsunset. (╥﹏╥)"
        echo "[ ERROR ] - Sorry, could not install Hyprsunset. (╥﹏╥)\n" 2>&1 | tee -a "$log" &> /dev/null
    fi 
fi

sleep 1 && clear