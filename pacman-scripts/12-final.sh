#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Shell Ninja ( https://github.com/shell-ninja ) ####

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
   ____ _             __
  / __/(_)___  ___ _ / /
 / _/ / // _ \/ _ `// / 
/_/  /_//_//_/\_,_//_/  
                        
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
log="$log_dir/final_checkup-$(date +%d-%m-%y).log"

# skip installed cache
installed_cache="$parent_dir/.cache/installed_packages"

if [[ ! -f "$log" ]]; then
    mkdir -p "$log_dir"
    touch "$log"
fi

aur_helper=$(command -v yay || command -v paru) # find the aur helper

checkup=(
    btop
    cava
    cliphist
    curl
    dunst
    eog
    fastfetch
    ffmpeg
    ffmpegthumbnailer
    file-roller
    grimblast-git
    gnome-disk-utility
    gvfs
    gvfs-mtp
    hyprland
    hyprlock
    hyprpaper
    hypridle
    hyprcursor
    hyprsunset
    hyprland-qtutils
    imagemagick
    jq
    kitty
    kvantum
    kvantum-qt5
    lxappearance
    mate-polkit
    network-manager-applet
    networkmanager
    nodejs
    npm
    ntfs-3g
    nwg-look
    nvtop
    os-prober
    pacman-contrib
    pamixer
    pavucontrol
    pciutils
    python-pywal
    pyprland
    qt5ct
    qt5-svg
    qt6ct
    qt6-svg
    qt6-5compat
    qt6-declarative
    qt6-svg
    qt5-graphicaleffects
    qt5-quickcontrols2
    ripgrep
    rofi-wayland
    swappy
    swww
    sddm
    thunar
    thunar-volman
    tumbler
    thunar-archive-plugin
    tty-clock
    unzip
    waybar
    wget
    wl-clipboard
    xorg-xrandr
    yazi
    zip
)


# checking already installed packages 
for skipable in "${checkup[@]}"; do
    skip_installed "$skipable" &> /dev/null
done

to_install=($(printf "%s\n" "${hypr_packages[@]}" | grep -vxFf "$installed_cache"))

printf "\n\n"

# Instlling main packages...
for hypr_pkgs in "${to_install[@]}"; do
    msg act "Somehow $hypr_pkgs could not be installed before. Installing it now..."
    aur_helper -Syy "$hypr_pkgs" --noconfirm &> /dev/null

    if sudo pacman -Q "$hypr_pkgs" &> /dev/null; then

        msg dn "Finally $hypr_pkgs was installed successfully!"
        echo

        echo "[ DONE ] - $hypr_pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &>/dev/null
    else

        msg err "Sorry, this time also could not install $hypr_pkgs.."
        echo

        echo "[ ERROR ] - Sorry, could not install $hypr_pkgs!\n" 2>&1 | tee -a "$log" &>/dev/null
    fi
done

sleep 1 && clear
