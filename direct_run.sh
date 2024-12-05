#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Js Bro ( https://github.com/me-js-bro ) ####

# this script will be a curl of wget link. by running this script, it will clone the repository and execute the main script.

# exit the script if there's any error
set -e

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

printf "${orange}[ * ] Starting the script.. Please have patience..${end} (•‿•)\n" && sleep 2

install_git() {

    if [ -n "$(command -v pacman)" ]; then  # Arch Linux

        if ! pacman -Qe git &> /dev/null; then
            sudo pacman -S --noconfirm git
        fi

    elif [ -n "$(command -v dnf)" ]; then  # Fedora

        if sudo dnf list installed git &> /dev/null; then
            sudo dnf install -y git
        fi

    elif [ -n "$(command -v zypper)" ]; then  # openSUSE

        if sudo zypper se -i git &> /dev/null; then
            sudo zypper in --no-recommends -y git
        fi

    else
        printf "! Unsupported distribution for now..Sorry.\n"
        exit 1
    fi
}

install_git && printf "${cyan}[ * ] Git was installed..${end}\n"

sleep 1

printf "\n${green}[ * ] Cloning the installation repository... Please have patience... ${end}\n"

[[ "$(pwd)" != "$HOME" ]] && cd "$HOME"

git clone --depth=1 https://github.com/me-js-bro/hyprconf-install.git &> /dev/null

if [[ -d "hyprconf-install" ]]; then
    printf "\n${cyan}[ * ] Repository was clonned successfully!${end} \n${green}[ * ] Now starting the main script... ${end}\n" && sleep 1 && clear

    cd hyprconf-install
    chmod +x start.sh
    ./start.sh
fi