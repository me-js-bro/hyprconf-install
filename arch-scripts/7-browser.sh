#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Js Bro ( https://github.com/me-js-bro ) ####

# exit the script if there is any error
# set -e

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

parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

# log directory
log_dir="$parent_dir/Logs"
log="$log_dir/browser-$(date +%d-%m-%y).log"

if [[ -f "$log" ]]; then
    errors=$(grep "ERROR" "$log")
    finished=$(grep -c "DONE" "$log")
    if [[ -z "$errors" && "$finished" -gt 0 ]]; then
        printf "${note}\n;; No need to run this script again\n"
        sleep 2
        exit 0
    fi

else
    mkdir -p "$log_dir"
    touch "$log"
fi

# finding the aur helper
aur_helper=$(command -v yay || command -v paru)

# Ask user for browser selection
printf "${ask}\n? Choose which browser would you like to install. You can choose multiple.\n"
browsers=$(gum choose --no-limit "Brave" "Chromium" "Firefox" "Vivaldi" "Zen Browser")

# Fix: Convert gum choice string into an array
IFS=$'\n' read -r -d '' -a browser_array <<<"$browsers"

# Loop through the selected browsers
for browser in "${browser_array[@]}"; do
    case $browser in
    "Brave")
        curl -fsS https://dl.brave.com/install.sh | sh
        sleep 1

        if [[ -n "$(command -v brave)" ]]; then
            printf "${done}\n:: Brave was installed successfully!\n"
            echo "[ DONE ] - Brave was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null

            printf "${attention}\n! After completting the installation, please make sure to open the browser and follow the steps.\n" && sleep 2 && echo

            printf "[ 1 ] - Open the browser and in the search bar, typr 'chrome://flags' and press enter\n"
            printf "[ 2 ] - Now search for 'Ozone platform'\n"
            printf "[ 3 ] - Choose 'Wayland' from default and restart the browser.\n"
            sleep 5
        else 
            printf "${error}\n! Could not installed Brave\n"
            echo "[ ERROR ] - Could not install Brave" 2>&1 | tee -a "$log" &> /dev/null
        fi
        ;;
    "Chromium")
        install_package chromium
        sleep 1

        if [[ -n "$(command -v chromium)" ]]; then
            printf "${done}\n:: Chromium was installed successfully!\n"
            echo "[ DONE ] - Chromium was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null

            printf "${attention}\n! After completting the installation, please make sure to open the browser and follow the steps.\n" && sleep 2 && echo

            printf "[ 1 ] - Open the browser and in the search bar, typr 'chrome://flags' and press enter\n"
            printf "[ 2 ] - Now search for 'Ozone platform'\n"
            printf "[ 3 ] - Choose 'Wayland' from default and restart the browser.\n"
            sleep 5
        else 
            printf "${error}\n! Could not installed Chromium\n"
            echo "[ ERROR ] - Could not install Chromium" 2>&1 | tee -a "$log" &> /dev/null
        fi
        ;;
    "Firefox")
        install_package firefox
        sleep 1

        if [[ -n "$(command -v firefox)" ]]; then
            printf "${done}\n:: Firefox was installed successfully!\n"
            echo "[ DONE ] - Firefox was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
        else 
            printf "${error}\n! Could not installed firefox\n"
            echo "[ ERROR ] - Could not install firefox" 2>&1 | tee -a "$log" &> /dev/null
        fi
        ;;
    "Vivaldi")
        install_package vivaldi
        sleep 1

        if [[ -n "$(command -v vivaldi)" ]]; then
            printf "${done}\n:: Vivaldi was installed successfully!\n"
            echo "[ DONE ] - Vivaldi was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null

            printf "${attention}\n! After completting the installation, please make sure to open the browser and follow the steps.\n" && sleep 2 && echo

            printf "[ 1 ] - Open the browser and in the search bar, typr 'chrome://flags' and press enter\n"
            printf "[ 2 ] - Now search for 'Ozone platform'\n"
            printf "[ 3 ] - Choose 'Wayland' from default and restart the browser.\n"
            sleep 5
        else 
            printf "${error}\n! Could not installed Vivaldi\n"
            echo "[ ERROR ] - Could not install Vivaldi" 2>&1 | tee -a "$log" &> /dev/null
        fi
        ;;
    "Zen Browser")
        install_from_aur zen-browser-avx2-bin
        sleep 1

        if [[ -n "$(command -v zen-browser)" ]]; then
            printf "${done}\n:: Zen Browser was installed successfully!\n"
            echo "[ DONE ] - Zen Browser was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
        else 
            printf "${error}\n! Could not installed zen\n"
            echo "[ ERROR ] - Could not install zen" 2>&1 | tee -a "$log" &> /dev/null
        fi

        ;;
    *)
        printf "${error}\n! Invalid choice: $browser\n"
        ;;
    esac
done

sleep 1 && clear
