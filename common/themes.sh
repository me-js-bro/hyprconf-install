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

display_text() {
    gum style \
        --border rounded \
        --align center \
        --width 60 \
        --margin "1" \
        --padding "1" \
'
 ________                
/_  __/ /  ___ __ _  ___ 
 / / / _ \/ -_)  ; \/ -_)
/_/ /_//_/\__/_/_/_/\__/ 
                          
                               
'
}

clear && display_text
printf " \n \n"

printf " \n"

###------ Startup ------###

# finding the presend directory and log file
# install script dir
dir="$(dirname "$(realpath "$0")")"

# log directory
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

log_dir="$parent_dir/Logs"
log="$log_dir/themes-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# Install theme
theme="$parent_dir/assets/themes.zip"
icon="$parent_dir/assets/Icon_TelaDracula.tar.gz"
cursor="$parent_dir/assets/Bibata-Modern-Ice.tar.xz"
nwg="$parent_dir/assets/nwg-look"

# creating icons and theme directory
mkdir -p ~/.themes
mkdir -p ~/.icons

# installing tokyo night icons.
Download_URL="https://github.com/ljmill/tokyo-night-icons/releases/latest/download/TokyoNight-SE.tar.bz2"

if [ ! -d "$HOME/.icons/TokyoNight-SE" ]; then
    msg act "Installing Tokyo Night icons..."

    # if the tokyo night icon directory was not downloaded, it will download if first
    if [ ! -d "TokyoNight-SE.tar.bz2" ]; then
        for ((attempt=1; attempt<=2; attempt++)); do
            curl -OL $Download_URL 2>&1 | tee -a "$log" && break &> /dev/null
            msg nt "Tried $attempt time, trying again.." 2>&1 | tee -a "$log"
            sleep 2
        done
    fi

    # extracting the icon
    tar -xf TokyoNight-SE.tar.bz2 -C ~/.icons/ &> /dev/null 2>&1 | tee -a "$log"
    tar -xf "$icon" -C ~/.icons/ &> /dev/null 2>&1 | tee -a "$log"

    sleep 2

    if [[ -d "$HOME/.icons/TokyoNight-SE" ]]; then
        msg dn "Successfully Installed Tokyo Night icons..."
        echo "[ DONE ] - Successfully Installed Tokyo Night icons. \n" 2>&1 | tee -a "$log" &> /dev/null
        rm -rf "TokyoNight-SE.tar.bz2"
    else
        msg err "Could not install Tokyo Night icons.."
        echo "[ ERROR ] - Could not install Tokyo Night icons. (╥﹏╥)\n" 2>&1 | tee -a "$log" &> /dev/null
    fi
fi

# installing the cursor
tar -xf "$cursor" -C ~/.icons/ &> /dev/null 2>&1 | tee -a "$log"

# clear

# extracting themes to ~/.themes/
msg act "Copying themes.."
unzip -o "$theme" -d "$parent_dir/.cache/" &> /dev/null 2>&1 | tee -a "$log"
if [[ -d "$parent_dir/.cache/themes" ]]; then
    cp -r "$parent_dir/.cache/themes"/* "$HOME/.themes/"
fi

[[ -d "$HOME/.local/share/nwg-look" ]] && rm -rf "$HOME/.local/share/nwg-look"
cp -r "$nwg" "$HOME/.local/share/"

msg dn "Themes copied successfully."

sleep 1

# setting default themes, icon and cursor
gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
gsettings set org.gnome.desktop.interface icon-theme "TokyoNight-SE"
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"

sleep 1 && clear
