#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Shell Ninja ( https://github.com/shell-ninja ) ####

# color definition
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"

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
log="$log_dir/hyprland-$(date +%d-%m-%y).log"

# skip installed cache
cache_dir="$parent_dir/.cache"
installed_cache="$cache_dir/installed_packages"

mkdir -p "$log_dir"
touch "$log"

# Ask user for browser selection
browsers=$(gum choose --header "Choose the browser you want to install (only one)" "Brave" "Chromium" "Firefox" "Vivaldi" "Zen Browser" "Skip")

case $browsers in
    "Brave")
        msg act "Installing Brave..."
        curl -fsS https://dl.brave.com/install.sh | sh
        sleep 1

        if [[ -n "$(command -v brave-browser)" ]]; then
            msg dn "Brave was installed successfully!"
            echo "[ DONE ] - Brave was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null

            msg att "After completting the installation, please make sure to open the browser and follow the steps..." && sleep 2 && echo

            printf "[ 1 ] - Open the browser and in the search bar, typr 'chrome://flags' and press enter\n"
            printf "[ 2 ] - Now search for 'Ozone platform'\n"
            printf "[ 3 ] - Choose 'Wayland' from default and restart the browser.\n"
            sleep 5
        else 
            msg err "Could not installed Brave.."
            echo "[ ERROR ] - Could not install Brave" 2>&1 | tee -a "$log" &> /dev/null
        fi

        ;;
    "Chromium")
        msg act "Installing Chromium..."
        install_package chromium
        sleep 1

        if [[ -n "$(command -v chromium)" ]]; then
            msg dn "Chromium was installed successfully!"
            echo "[ DONE ] - Chromium was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null

            msg att "After completting the installation, please make sure to open the browser and follow the steps..." && sleep 2 && echo

            printf "[ 1 ] - Open the browser and in the search bar, typr 'chrome://flags' and press enter\n"
            printf "[ 2 ] - Now search for 'Ozone platform'\n"
            printf "[ 3 ] - Choose 'Wayland' from default and restart the browser.\n"
            sleep 5
        else 
            msg err "Could not installed Chromium.."
            echo "[ ERROR ] - Could not install Chromium" 2>&1 | tee -a "$log" &> /dev/null
        fi
        ;;
    "Firefox")
        install_package firefox
        ;;
    "Vivaldi")
        msg act "Installing Vivaldi..."
        install_package_opi vivaldi
        sleep 1

        if [[ -n "$(command -v chromium)" ]]; then
            msg dn "Vivaldi was installed successfully!"
            echo "[ DONE ] - Vivaldi was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null

            msg att "After completting the installation, please make sure to open the browser and follow the steps..." && sleep 2 && echo

            printf "[ 1 ] - Open the browser and in the search bar, typr 'chrome://flags' and press enter\n"
            printf "[ 2 ] - Now search for 'Ozone platform'\n"
            printf "[ 3 ] - Choose 'Wayland' from default and restart the browser.\n"
            sleep 5
        else 
            msg err "Could not installed Vivaldi.."
            echo "[ ERROR ] - Could not install Vivaldi" 2>&1 | tee -a "$log" &> /dev/null
        fi
        ;;
    "Zen Browser")
        msg act "Installing Zen-Browser..."
        install_package_opi zen-browser
        ;;
    "Skip")
        msg skp "No browsers will be installed.."
        sleep 1
        exit 0
        ;;
    *)
        msg err "Invalid choice: $browser..."
        ;;
esac

sleep 1 && clear
