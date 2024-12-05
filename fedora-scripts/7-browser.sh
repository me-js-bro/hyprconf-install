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
        --width 40 \
        --margin "1" \
        --padding "1" \
'
   ___                            
  / _ )_______ _    _____ ___ ____
 / _  / __/ _ \ |/|/ (_-</ -_) __/
/____/_/  \___/__,__/___/\__/_/

'
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# log directory
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

log_dir="$parent_dir/Logs"
log="$log_dir/browser-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# asking which browser wants to install
fn_choose "Which browser would you like to install? You can install multiple" "Firefox" "Brave" "Chromium"
browsers=(${choice[@]})

# Split the choices into an array
IFS=$'\n' read -r -d '' -a browsers <<<"$choice"

# Loop through the selected browsers
for browser in "${browsers[@]}"; do
    case $browser in
        "Firefox")
            install_package firefox
            ;;
        "Brave")
            sudo dnf install -y dnf-plugins-core 2>&1 | tee -a "$log"
            sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo 2>&1 | tee -a "$log"
            sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc 2>&1 | tee -a "$log"
            install_package brave-browser
            ;;
        "Chromium")
            install_package chromium
            ;;
    esac
done

sleep 1 && clear