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
   _______  ___  __  ___
  / __/ _ \/ _ \/  |/  /
 _\ \/ // / // / /|_/ / 
/___/____/____/_/  /_/   

'
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

parent_dir="$(dirname "$dir")"
common_scripts="$parent_dir/common"
source "$parent_dir/interaction_fn.sh"

# log directory
log_dir="$parent_dir/Logs"
log="$log_dir/sddm-$(date +%d-%m-%y).log"

if [[ -f "$log" ]]; then
    source "$log"

    errors=$(grep "ERROR" "$log")
    if [[ -z "$errors" ]]; then
        printf "${note}\n;; No need to run this script again\n"
        sleep 2
        exit 0
    fi

else
    mkdir -p "$log_dir"
    touch "$log"
fi


# packages for sddm
sddm=(
    qt6-5compat
    qt6-declarative
    qt6-svg
    sddm
)

# Installation of additional sddm stuff
printf "${action}\n==> Installing sddm and dependencies.\n"
for sddm_pkgs in "${sddm[@]}"; do
    install_package "$sddm_pkgs"
    if sudo pacman -Qe "$sddm_pkgs" &>/dev/null; then
        echo "[ DONE ] - $sddm_pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &>/dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $sddm_pkgs!\n" 2>&1 | tee -a "$log" &>/dev/null
    fi
done

# Check if other login managers are installed and disabling their service before enabling sddm
for login_manager in lightdm gdm lxdm lxdm-gtk3; do
    if sudo pacman -Qs "$login_manager" 2>&1 | tee -a "$log" &>/dev/null; then
        echo "Disabling $login_manager..."
        sudo systemctl disable "$login_manager" 2>&1 | tee -a "$log"
    fi
done

printf "${action}\n==> Activating sddm service.\n"
sudo systemctl enable sddm.service 2>&1 | tee -a "$log"

# run sddm theme script
"$common_scripts/sddm_theme.sh"

clear
