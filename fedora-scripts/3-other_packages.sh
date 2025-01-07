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

# skip installed cache
cache_dir="$parent_dir/.cache"
installed_cache="$cache_dir/installed_packages"

# log dir
log_dir="$parent_dir/Logs"
log="$log_dir/others-$(date +%d-%m-%y).log"

# log directory
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

main_packages=(
  curl
  eog
  fastfetch
  ffmpeg-free
  git
  grim
  ImageMagick
  jq
  kitty
  kvantum
  libX11-devel
  libXext-devel
  lxappearance
  mate-polkit
  make
  network-manager-applet
  NetworkManager-tui
  neovim
  nvtop
  pamixer
  pavucontrol
  pipewire-alsa
  pipewire-utils
  pulseaudio-utils
  python3-requests
  python3-devel
  python3-pip
  python3-pillow
  python3-pyquery
  qt5ct
  qt6ct
  qt6-qtsvg
  ripgrep
  rofi-wayland
  slurp
  swappy
  tar
  unzip
  waybar
  wget2
  wl-clipboard
  xdg-utils
  yad
  yazi
)

# other necessary packages
other_packages=(
  btop
  cava
  cliphist
  gnome-disk-utility 
  mpv
  mpv-mpris
  nwg-look
  pamixer
  SwayNotificationCenter
  swww
)

# thunar file manager
thunar=(
  ffmpegthumbnailer
  file-roller
  gvfs
  gvfs-mtp 
  Thunar 
  thunar-volman 
  tumbler 
  thunar-archive-plugin
)

# url to install grimblast
grimblast_url=https://github.com/hyprwm/contrib.git

# checking already installed packages 
for skipable in "${main_packages[@]}" "${other_packages[@]}" "${thunar[@]}"; do
    skip_installed "$skipable"
done

installble_main_pkg=($(printf "%s\n" "${main_packages[@]}" | grep -vxFf "$installed_cache"))
installble_other_pkg=($(printf "%s\n" "${other_packages[@]}" | grep -vxFf "$installed_cache"))
installble_thunar_pkg=($(printf "%s\n" "${thunar[@]}" | grep -vxFf "$installed_cache"))

printf "\n\n"

# installing necessary packages
for packages in "${installble_main_pkg[@]}" "${installble_other_pkg[@]}" "${installble_thunar_pkg[@]}"; do
  install_package "$packages"
  if rpm -q "$packages" &> /dev/null; then
    echo "[ DONE ] - $packages was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
  else
    echo "[ ERROR ] - Sorry, could not install '$packages'" 2>&1 | tee -a "$log" &> /dev/null
  fi
done

# installing grimblast
if [ -f '/usr/local/bin/grimblast' ]; then
  msg dn "Grimblast is already installed..." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
else

  msg act "Installing Grumblast..."
  git clone --depth=1 "$grimblast_url" "$parent_dir/.cache/grimblast/" 2>&1 | tee -a "$log" &> /dev/null
  cd "$parent_dir/.cache/grimblast/grimblast"
  make 2>&1 | tee -a "$log" &> /dev/null
  sudo make install 2>&1 | tee -a "$log" &> /dev/null

  sleep 1
  rm -rf "$parent_dir/.cache/grimblast" 2>&1 | tee -a "$log"
fi

if [ -f '/usr/local/bin/grimblast' ]; then
  msg dn "Grimblast was installed successfully..."
  printf "[ DONE ] - Grimblast was installed successfully...\n" 2>&1 | tee -a "$log"
fi

sleep 1 && clear

if [ -z "$(command -v wal)" ]; then
    # installing pywal
    "$dir/pywal.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi
