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
     ____              _     _                  ____               _          _           
    |  _ \   ___  ___ | | __| |_  ___   _ __   |  _ \  ___   _ __ | |_  __ _ | |          
    | | | | / _ \/ __|| |/ /| __|/ _ \ | '_ \  | |_) |/ _ \ | '__|| __|/ _` || |          
    | |_| ||  __/\__ \|   < | |_| (_) || |_) | |  __/| (_) || |   | |_| (_| || |  _  _  _ 
    |____/  \___||___/|_|\_\ \__|\___/ | .__/  |_|    \___/ |_|    \__|\__,_||_| (_)(_)(_)
                                       |_|                                                   
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# log directory
parent_dir="$(dirname "$dir")"
log_dir="$parent_dir/Logs"
log="$log_dir/xdg_dp-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

xdg=(
xdg-desktop-portal-hyprland
xdg-desktop-portal-gtk
)


# XDG-DESKTOP-PORTAL-HYPRLAND
for xdgs in "${xdg[@]}"; do
  install_package "$xdgs" "$log"
done

printf "\n"

printf "${attention} - Checking for other XDG-Desktop-Portal-Implementations....\n \n"
sleep 1
printf "${note} XDG-desktop-portal-KDE & GNOME (if installed) should be manually disabled or removed! I can't remove it... sorry...\n"
while true; do
    if [[ -z $xdg_dp ]]; then
      printf "${attention} - Would you like to try to remove other XDG-Desktop-Portal-Implementations? [ y/n ]\n"
      read -r -p "$(echo -e '\e[1;32mSelect: \e[0m')" xdg_dp
    fi
    echo
    sleep 1

    case $xdg_dp in
        [Yy])
            # Clean out other portals
            printf "${action} - Clearing other xdg-desktop-portal implementations...\n"
            # Check if packages are installed and uninstall if present
            if pacman -Qs xdg-desktop-portal-wlr > /dev/null ; then
                echo "Removing xdg-desktop-portal-wlr..."
                sudo pacman -R --noconfirm xdg-desktop-portal-wlr 2>&1 | tee -a "$log"
            fi
            if pacman -Qs xdg-desktop-portal-lxqt > /dev/null ; then
                echo "Removing xdg-desktop-portal-lxqt..."
                sudo pacman -R --noconfirm xdg-desktop-portal-lxqt 2>&1 | tee -a "$log"
            fi
            break
            ;;
        [Nn])
            echo "no other XDG-implementations will be removed." >> "$log"
            break
            ;;
        *)
            echo "Invalid input. Please enter 'y' for yes or 'n' for no."
            ;;
    esac
done