#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Js Bro ( https://github.com/me-js-bro ) ####

# exit the script if there is any error
set -e

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

# finding the aur helper
aur_helper=$(command -v yay || command -v paru)

# Ask user for browser selection
printf "${ask}\n? Choose which browser would you like to install. You can choose multiple.\n"
browsers=$(gum choose --no-limit "Brave" "Chromium" "Firefox" "Vivaldi" "Zen Browser")

# Fix: Convert gum choice string into an array
IFS=$'\n' read -r -d '' -a browser_array <<< "$browsers"

# Loop through the selected browsers
for browser in "${browser_array[@]}"; do
    case $browser in
        "Brave")
            install_from_aur brave-bin
            sleep 1
            printf "${attention}\n! After completting the installation, please make sure to open the browser and follow the steps.\n" && sleep 2 && echo

            printf "[ 1 ] - Open the browser and in the search bar, typr 'chrome://flags' and press enter\n"
            printf "[ 2 ] - Now search for 'Ozone platform'\n"
            printf "[ 3 ] - Choose 'Wayland' from default and restart the browser.\n"

            sleep 3
            ;;
        "Chromium")
            install_from_aur ungoogled-chromium-bin
            sleep 1
            printf "${attention}\n! After completting the installation, please make sure to open the browser and follow the steps.\n" && sleep 2 && echo

            printf "[ 1 ] - Open the browser and in the search bar, typr 'chrome://flags' and press enter\n"
            printf "[ 2 ] - Now search for 'Ozone platform'\n"
            printf "[ 3 ] - Choose 'Wayland' from default and restart the browser.\n"

            sleep 3
            ;;
        "Firefox")
            install_package firefox
            ;;
        "Vivaldi")
            install_package vivaldi
            sleep 1
            printf "${attention}\n! After completting the installation, please make sure to open the browser and follow the steps.\n" && sleep 2 && echo

            printf "[ 1 ] - Open the browser and in the search bar, typr 'chrome://flags' and press enter\n"
            printf "[ 2 ] - Now search for 'Ozone platform'\n"
            printf "[ 3 ] - Choose 'Wayland' from default and restart the browser.\n"

            sleep 3
            ;;
        "Zen Browser")
            install_from_aur zen-browser-avx2-bin
            ;;
        *)
            printf "${error}\n! Invalid choice: $browser\n"
            ;;
    esac
done

sleep 1 && clear
