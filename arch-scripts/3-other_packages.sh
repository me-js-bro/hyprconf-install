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

display_text() {
    gum style \
        --border rounded \
        --align center \
        --width 40 \
        --margin "1" \
        --padding "1" \
        '
  ____  __  __             
 / __ \/ /_/ /  ___ _______
/ /_/ / __/ _ \/ -_) __(_-<
\____/\__/_//_/\__/_/ /___/
                             
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
log="$log_dir/others-$(date +%d-%m-%y).log"

# skip installed cache
cache_dir="$parent_dir/.cache"
installed_cache="$cache_dir/installed_packages"

if [[ -f "$log" ]]; then
    errors=$(grep "ERROR" "$log")
    last_installed=$(grep "thunar-archive-plugin" "$log" | awk {'print $2'})
    if [[ -z "$errors" && "$last_installed" == "DONE" ]]; then
        msg skp "Skipping this script. No need to run it again..."
        sleep 1
        exit 0
    fi

else
    mkdir -p "$log_dir"
    touch "$log"
fi

# any other packages will be installed from here
other_packages=(
    btop
    curl
    fastfetch
    ffmpeg
    gnome-disk-utility
    ibus
    imagemagick
    jq
    kvantum
    lxappearance
    network-manager-applet
    networkmanager
    nodejs
    npm
    ntfs-3g
    nvtop
    os-prober
    pacman-contrib
    pamixer
    pavucontrol
    pciutils
    python-pillow
    python-pywal
    ripgrep
    unzip
    wget
    xorg-xrandr
    yad
    yazi
    zip
)

aur_packages=(
    cava
    grimblast-git
    hyprsunset
    hyprland-qtutils
    tty-clock
)

# thunar file manager
thunar=(
    ffmpegthumbnailer
    file-roller
    gvfs
    gvfs-mtp
    thunar
    thunar-volman
    tumbler
    thunar-archive-plugin
)

# checking already installed packages 
for skipable in "${other_packages[@]}" "${aur_packages[@]}" "${thunar[@]}"; do
    skip_installed "$skipable"
done

installble_pkg=($(printf "%s\n" "${other_packages[@]}" | grep -vxFf "$installed_cache"))
installble_aur_pkg=($(printf "%s\n" "${aur_packages[@]}" | grep -vxFf "$installed_cache"))
installble_thunar_pkg=($(printf "%s\n" "${thunar[@]}" | grep -vxFf "$installed_cache"))

printf "\n\n"

for other_pkgs in "${installble_pkg[@]}"; do
    install_package "$other_pkgs"
    if sudo pacman -Q "$other_pkgs" &>/dev/null; then
        echo "[ DONE ] - $other_pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &>/dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $other_pkgs!\n" 2>&1 | tee -a "$log" &>/dev/null
    fi
done

sleep 1 && clear

# Installing from the AUR Helper
for aur_pkgs in "${installble_aur_pkg[@]}"; do
    install_from_aur "$aur_pkgs"
    if sudo "$aur_helper" -Q "$aur_pkgs" &>/dev/null; then
        echo "[ DONE ] - $aur_pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &>/dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $aur_pkgs!\n" 2>&1 | tee -a "$log" &>/dev/null
    fi
done

sleep 1 && clear

# installing thunar file manager
for file_man in "${installble_thunar_pkg[@]}"; do
    install_package "$file_man"
    if sudo pacman -Q "$file_man" &>/dev/null; then
        echo "[ DONE ] - $file_man was installed successfully!\n" 2>&1 | tee -a "$log" &>/dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $file_man!\n" 2>&1 | tee -a "$log" &>/dev/null
    fi
done

sleep 1 && clear
