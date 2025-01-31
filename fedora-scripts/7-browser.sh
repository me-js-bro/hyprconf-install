#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Shell Ninja ( https://github.com/shell-ninja ) ####

# color defination
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
log="$log_dir/browser-$(date +%d-%m-%y).log"

if [[ -f "$log" ]]; then
    errors=$(grep "ERROR" "$log")
    finished=$(grep -c "DONE" "$log")
    if [[ -z "$errors" && "$finished" -gt 0 ]]; then
        msg skp "Skipping this script. No need to run it again..."
        sleep 1
        exit 0
    fi

else
    mkdir -p "$log_dir"
    touch "$log"
fi

# Ask user for browser selection
browsers=$(gum choose --no-limit \
        --header "You can choose multiple browsers" \
        --header.foreground "#fff" \
        --cursor.foreground "#00FFFF" \
        --item.foreground "#00FFFF" \
        --selected.foreground "#00FF00" \
        "Brave" "Chromium" "Firefox" "Zen Browser"
)

# Fix: Convert gum choice string into an array
IFS=$'\n' read -r -d '' -a browser_array <<< "$browsers"

# Loop through the selected browsers
for browser in "${browser_array[@]}"; do
    case $browser in
        "Brave")
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
            sleep 1

            if [[ -n "$(command -v firefox)" ]]; then
                msg dn "Firefox was installed successfully!"
                echo "[ DONE ] - Firefox was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
            else 
                msg err "Could not installed firefox.."
                echo "[ ERROR ] - Could not install firefox" 2>&1 | tee -a "$log" &> /dev/null
            fi
            ;;
        "Zen Browser")
            msg act "Installing the zen-browser..." && sleep 0.5
            msg att "Enabling the copr repo for it..."
            sudo dnf copr enable sneexy/zen-browser -y
            sudo wget "https://copr.fedorainfracloud.org/coprs/sneexy/zen-browser/repo/fedora-$(rpm -E %fedora)/sneexy-zen-browsder-fedora-$(rpm -E %fedora).repo" -O "/etc/yum.repos.d/_copr_sneexy-zen-browser.repo"
            sleep 1
            sudo dnf install zen-browser-avx2 -y
            sleep 1

            if [[ -n "$(command -v zen-browser)" ]]; then
                msg dn "Zen Browser was installed successfully!"
                echo "[ DONE ] - Zen Browser was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
            else 
                msg err "Could not installed Zen Browser.."
                echo "[ ERROR ] - Could not install Zen Browser" 2>&1 | tee -a "$log" &> /dev/null
            fi
            ;;
            *)
              msg err "Invalid choice: $browser..."
            ;;
    esac
done

sleep 1 && clear
