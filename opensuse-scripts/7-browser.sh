#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Js Bro ( https://github.com/me-js-bro ) ####

# color definition
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

brave="$parent_dir/assets/BraveSoftware.zip"
chromium="$parent_dir/assets/chromium.zip"

# Ask user for browser selection
printf "${ask}\n? Choose which browser would you like to install. You can choose multiple.\n"
browsers=$(gum choose --no-limit "Brave" "Chromium" "Firefox" "Vivaldi" "Zen")

# Fix: Convert gum choice string into an array
IFS=$'\n' read -r -d '' -a browser_array <<< "$browsers"

# Loop through the selected browsers
for browser in "${browser_array[@]}"; do
    case $browser in
        "Brave")
            printf "${action}\n==> Installing Brave\n"
            sudo opi brave-browser -n
            sleep 1
            if [[ -d "$HOME/.config/BraveSoftware" ]]; then
                mkdir -p "$HOME/.config/browser-backup"
                mv "$HOME/.config/BraveSoftware" "$HOME/.config/browser-backup/" &> /dev/null
            fi
            unzip "$brave" -d "$HOME/.config/" &> /dev/null
            ;;
        "Chromium")
            printf "${action}\n==> Installing Chromium\n"
            install_package chromium
            sleep 1
            if [[ -d "$HOME/.config/chromium" ]]; then
                mkdir -p "$HOME/.config/browser-backup"
                mv "$HOME/.config/chromium" "$HOME/.config/browser-backup" &> /dev/null
            fi
            unzip "$chromium" -d "$HOME/.config/" &> /dev/null
            ;;
        "Firefox")
            install_package firefox
            ;;
        "Vivaldi")
            printf "${action}\n==> Installing Vivaldi\n"
            sudo opi vivaldi -n
            ;;
        "Zen")
            printf "${action}\n==> Installing Zen-Browser\n"
            sudo opi zen-browser -n
            ;;
        *)
            printf "${error}\n==> Invalid choice: $browser\n"
            ;;
    esac
done

# sleep 1 && clear
