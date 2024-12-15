#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Js Bro ( https://github.com/me-js-bro ) ####

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

# initial texts
attention="[${orange} ATTENTION ${end}]"
action="[${green} ACTION ${end}]"
note="[${magenta} NOTE ${end}]"
done="[${cyan} DONE ${end}]"
ask="[${orange} QUESTION ${end}]"
error="[${red} ERROR ${end}]"

dir="$(dirname "$(realpath "$0")")"
start="$dir/start.sh"

clear && sleep 1

typewriter() {
    local text="$1"
    local delay="$2"
    printf "[ * ]\n"
    for ((i = 0; i < ${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
    printf "${end}\n"
}

# Call the function with the message and a delay of 0.05 seconds
completed="Starting the script.. Please have patience.. (•‿•)"
typewriter " $completed" 0.07
sleep 0.5 && echo
printf "${cyan}[ * ] Need to install some packages first, installing those.\n" && sleep 2

packages=(
    git
    gum
)

for pkg in "${packages[@]}"; do

    if command -v pacman &>/dev/null; then
        if sudo pacman -Q "$pkg" &>/dev/null; then
            printf "${done}\n:: $pkg was installed already...\n\n"
        else
            printf "${action}\n==>  Installing $pkg\n"
            if sudo pacman -S --noconfirm "$pkg"; then
                printf "${done}\n:: $pkg was installed successfully!\n\n"
            fi
        fi
    elif command -v zypper &>/dev/null; then

        if sudo zypper se -i "$pkg" &>/dev/null; then
            printf "${done}\n:: $pkg was installed already...\n\n"
        else
            printf "${action}\n==> Installing $pkg\n"
            if sudo zypper in -y "$pkg"; then
                printf "${done}\n:: $pkg was installed sucessfully!\n\n"
            fi
        fi
    fi

done

# only for fedora
if command -v dnf &>/dev/null; then

    if rpm -q git &>/dev/null; then
        printf "${done}\n:: git was installed already...\n\n"
    else
        printf "${action}\n==> Installing git\n"
        if sudo dnf install -y git; then
            printf "${done}\n:: git was installed successfully!\n\n"
        fi
    fi

    sleep 1

    printf "${action}\n==> Installing gum\n"
    echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo &>/dev/null

    sudo yum install --assumeyes gum

    if command -v gum &>/dev/null; then
        printf "${done}\n:: Gum was installed successfully!\n"
    fi
fi

sleep 1

chmod +x "$start"
"$start"
