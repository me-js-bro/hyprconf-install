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
__fonts="$parent_dir/.cache/6-fonts"

if [[ -f "$__fonts" ]]; then
    source "$__fonts"

    errors=$(grep "error" "$__fonts")
    if [[ -z "$errors" ]]; then
        printf "${note}\n;; No need to run this script again\n"
        exit 0

    elif [[ -n "$errors" ]]; then
        error_pkgs=($(grep "error" "$__fonts" | awk {'print $1'}))
            for __erros in "${error_pkgs[@]}"; do
                install_package "$__erros"
            done
    fi

elif [[ ! -f "$__fonts" ]]; then
    touch "$__fonts"
fi

source "$parent_dir/interaction_fn.sh"

# log directory
log_dir="$parent_dir/Logs"
log="$log_dir/fonts-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

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
    if sudo pacman -Qe "$font_pkgs" &>/dev/null; then
        echo "[ DONE ] - $font_pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &>/dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $font_pkgs!\n" 2>&1 | tee -a "$log" &>/dev/null

        if ! grep -q "$font_pkgs = 'error'" "$__fonts"; then
            echo "$font_pkgs = 'error'" >> "$__fonts" &> /dev/null
        fi

    fi
done

sleep 1 && clear
