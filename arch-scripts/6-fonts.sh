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
   ____          __    
  / __/__  ___  / /____
 / _// _ \/ _ \/ __(_-<
/_/  \___/_//_/\__/___/
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
log="$log_dir/fonts-$(date +%d-%m-%y).log"
if [[ -f "$log" ]]; then
    source "$log"

    errors=$(grep "ERROR" "$log")
    last_installed=$(grep "noto-fonts-emoji" "$log" | awk {'print $2'})
    if [[ -z "$errors" && "$last_installed" == "DONE" ]]; then
        printf "${note}\n;; No need to run this script again\n"
        sleep 2
        exit 0
    fi

else
    mkdir -p "$log_dir"
    touch "$log"
fi

# necessary fonts [ new installable fonts should be added here ]
fonts=(
    ttf-font-awesome
    ttf-cascadia-code
    ttf-jetbrains-mono-nerd
    ttf-meslo-nerd
    noto-fonts
    noto-fonts-emoji
)

printf "${action}\n==> Installing some necessary fonts\n"

for font_pkgs in "${fonts[@]}"; do
    install_package "$font_pkgs"
    if sudo pacman -Q "$font_pkgs" &>/dev/null; then
        echo "[ DONE ] - $font_pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &>/dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $font_pkgs!\n" 2>&1 | tee -a "$log" &>/dev/null
    fi
done

sleep 1 && clear
