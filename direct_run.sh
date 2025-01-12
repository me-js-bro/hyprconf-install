#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Js Bro ( https://github.com/me-js-bro ) ####

# this script will be a curl of wget link. by running this script, it will clone the repository and execute the main script.

# exit the script if there's any error
#set -e

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"

printf "${orange}==>${end} Starting the script.. Please have patience..\n" && sleep 2

packages=(
    git
    gum
)

for pkg in "${packages[@]}"; do

    if command -v pacman &> /dev/null; then
        if sudo pacman -Q "$pkg" &> /dev/null; then
            printf "${magenta}[ SKIP ]${end}Skipping $pkg, it was already installed..\n"
        else
            printf "${green}=>${end} Installing $pkg...\n"
            sudo pacman -S --noconfirm "$pkg" &> /dev/null

            if sudo pacman -Q "$pkg" &> /dev/null; then
                printf "${cyan}::${end} $pkg was installed successfully!\n"
            fi
        fi
    elif command -v zypper &> /dev/null; then

        if sudo zypper se -i "$pkg" &>/dev/null; then
            printf "${magenta}[ SKIP ]${end} Skipping $pkg, it was already installed..\n"
        else
            printf "${green}=>${end} Installing $pkg...\n"
            sudo zypper in -y "$pkg";

            if sudo zypper se -i "$pkg" &> /dev/null; then
                printf "${cyan}::${end} $pkg was installed sucessfully!\n"
            fi
        fi
    fi

done

# only for fedora
if command -v dnf &> /dev/null; then

    if rpm -q git &> /dev/null; then
        printf "${magenta}[ SKIP ]${end} Skipping git, it was already installed..\n"
    else
        printf "${green}=>${end} Installing git...\n"
        sudo dnf install -y git
        
        if rpm -q git; then
            printf "${cyan}::${end} git was installed successfully!\n"
        fi
    fi

    sleep 1

    if rpm -q gum &> /dev/null; then
        printf "${magenta}[ SKIP ]${end} Skipping gum, it was already installed..\n"
    else
        printf "${green}=>${end} Installing gum...\n"
    echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo &>/dev/null

    sudo yum install --assumeyes gum

    if rpm -q gum &> /dev/null; then
        printf "${cyan}::${end} Gum was installed successfully!\n"
    fi
fi

sleep 1
 
[[ ! "$(pwd)" == "$HOME" ]] && cd "$HOME"

gum spin --spinner minidot --title "Preparing the installation scripts..." -- git clone --depth=1 https://github.com/me-js-bro/hyprconf-install.git &> /dev/null

if [[ -d "hyprconf-install" ]]; then
    printf "${cyan}::${end} Starting the main script...\n" && sleep 1 && clear

    cd hyprconf-install
    chmod +x start.sh
    ./start.sh
fi
