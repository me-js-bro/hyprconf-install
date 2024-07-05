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
orange="\x1b[38;5;214m"
end="\e[1;0m"

# initial texts
attention="[${orange} ATTENTION ${end}]"
action="[${green} ACTION ${end}]"
note="[${magenta} NOTE ${end}]"
done="[${cyan} DONE ${end}]"
ask="[${orange} QUESTION ${end}]"
error="[${red} ERROR ${end}]"

display_text() {
    cat << "EOF"
     _____  _                                           
    |_   _|| |__    ___  _ __ ___    ___  ___           
      | |  | '_ \  / _ \| '_ ` _ \  / _ \/ __|          
      | |  | | | ||  __/| | | | | ||  __/\__ \  _  _  _ 
      |_|  |_| |_| \___||_| |_| |_| \___||___/ (_)(_)(_)
                                                      
EOF
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
log_dir="$parent_dir/Logs"
log="$log_dir/themes-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# Install THEME
CONFIG_DIR="$HOME/.config"
theme="$parent_dir/assets/themes.tar.gz"
icon="$parent_dir/assets/Icon_TelaDracula.tar.gz"
cursor="$parent_dir/assets/Nordzy-cursors.tar.gz"

# creating icons and theme directory
mkdir -p ~/.themes
mkdir -p ~/.icons

# installing tokyo night icons.
Download_URL="https://github.com/ljmill/tokyo-night-icons/releases/latest/download/TokyoNight-SE.tar.bz2"

if [ ! -d "$HOME/.icons/TokyoNight-SE" ]; then
    printf "${action} - Installing Tokyo Night icons.\n"

    # if the tokyo night icon directory was not downloaded, it will download if first
    if [ ! -d "TokyoNight-SE.tar.bz2" ]; then
        for ((attempt=1; attempt<=2; attempt++)); do
            curl -OL $Download_URL 2>&1 | tee -a "$log" && break
            printf "Tried $attempt time, trying again..\n" 2>&1 | tee -a "$log"
            sleep 2
        done
    fi

    # extracting the icon
    tar -xf TokyoNight-SE.tar.bz2 -C ~/.icons/ 2>&1 | tee -a "$log"
    tar -xf "$icon" -C ~/.icons/ 2>&1 | tee -a "$log"

    sleep 2

    if [[ -d "$HOME/.icons/TokyoNight-SE" ]]; then
        printf "${done} - Successfully Installed Tokyo Night icons. \n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    else
        printf "${error} - Could not install Tokyo Night icons.\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    fi
fi

# installing the cursor
tar -xf "$cursor" -C ~/.icons/

# clear

# setting environment variable for qt themes
env_file=/etc/environment
sudo sh -c "echo \"QT_QPA_PLATFORMTHEME='qt5ct'\" >> $env_file" 2>&1 | tee -a "$log"

# extracting themes to ~/.themes/
printf "${action} - Copying themes\n" && sleep 1
tar -xf "$theme" -C ~/.themes/

printf "${done} - Themes copied successfully...\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")

sleep 1

# setting default themes, icon and cursor
gsettings set org.gnome.desktop.interface gtk-theme "theme"
gsettings set org.gnome.desktop.interface icon-theme "TokyoNight-SE"
gsettings set org.gnome.desktop.interface cursor-theme "Nordzy-cursors"

# clear


