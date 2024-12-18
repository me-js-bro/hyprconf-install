#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Js Bro ( https://github.com/me-js-bro ) ####

# exit the script if there is any error
# set -e

# Color definition
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[38;5;214m"
end="\e[1;0m"

# Initial texts
attention="[${orange} ATTENTION ${end}]"
action="[${green} ACTION ${end}]"
note="[${magenta} NOTE ${end}]"
done="[${cyan} DONE ${end}]"
ask="[${orange} QUESTION ${end}]"
error="[${red} ERROR ${end}]"

display_text() {
    cat <<"EOF"
   ___             __ __    __            
  / _ |__ ______  / // /__ / /__  ___ ____
 / __ / // / __/ / _  / -_) / _ \/ -_) __/
/_/ |_\_,_/_/   /_//_/\__/_/ .__/\__/_/   
                          /_/                   
   
EOF
}

clear && display_text
printf " \n\n"

###------ Startup ------###

# Finding the present directory and log file

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# log directory
parent_dir="$(dirname "$dir")"
cache_file="$parent_dir/.cache/user-cache"

source "$parent_dir/interaction_fn.sh"

log_dir="$parent_dir/Logs"
log="$log_dir/aur_helper-$(date +%d-%m-%y).log"

# checking if the script already ran
if [[ -f "$log" ]]; then
    source "$log"

    error=$(grep "ERROR" "$log")
    if [[ -z "$error" ]]; then
        printf "${note}\n;; No need to run this script again.\n"
        exit 0
    fi
else
    mkdir -p "$log_dir"
    touch "$log"
fi

# Check for existing AUR helpers
aur_helper=$(command -v yay || command -v paru)

if [[ -f "$cache_file" ]]; then
    source "$cache_file"
fi

# install git before installing the aur helper.
if ! pacman -Qs git &>/dev/null; then
    printf "${action}\n==> Installing git & base-devel.\n"
    sudo pacman -S --noconfirm base-devel git 2>&1 | tee -a "$log" &>/dev/null
    fn_done "Git & base-devel was installed successfully!"
fi

if [[ -z "$aur_helper" ]]; then
    printf "${ask}\n?? Which aur helper would you like to install?\n"
    choice=$(gum choose --limit=1 "yay" "paru")

    if [[ "$choice" == "yay" ]]; then
        printf "${action}\n==> Installing yay.\n"
        sudo rm -rf /var/lib/pacman/db.lck
        echo "aur='yay'" >>"$cache_file"
        git clone https://aur.archlinux.org/yay.git "$parent_dir/.cache/yay"
        cd "$parent_dir/.cache/yay" || exit 1
        makepkg -si --noconfirm
        sleep 1
        cd "$parent_dir" || exit 1
        sudo rm -rf "$parent_dir/.cache/yay"
    elif [[ "$choice" == "paru" ]]; then
        printf "${action}\n==> Installing paru.\n"
        sudo rm -rf /var/lib/pacman/db.lck
        echo "aur='paru'" >> "$cache_file"
        git clone https://aur.archlinux.org/paru.git "$parent_dir/.cache/paru"
        cd "$parent_dir/.cache/paru" || exit 1
        makepkg -si --noconfirm
        sleep 1
        cd "$parent_dir" || exit 1
        sudo rm -rf "$parent_dir/.cache/paru"
    fi

elif [[ -n "$aur_helper" ]]; then
    fn_done "$aur_helper was already installed.."
    exit 0
fi

if [[ -n "$(command -v yay)" || -n "$(command -v paru)" ]]; then
    fn_done "Aur helper was installed successfully!"
    echo "[ DONE ] - Aur helper was installed successfully!" 2>&1 | tee -a "$log" &>/dev/null
else
    fn_error "Could not install aru helper. Maybe there was an issue. (╥﹏╥)"
    echo "[ ERROR ] - Could not install aru helper. Maybe there was an issue.(╥﹏╥)" 2>&1 | tee -a "$log" &>/dev/null
    exit 1
fi
