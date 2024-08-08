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

# initial texts
attention="[${orange} ATTENTION ${end}]"
action="[${green} ACTION ${end}]"
note="[${magenta} NOTE ${end}]"
done="[${cyan} DONE ${end}]"
ask="[${orange} QUESTION ${end}]"
error="[${red} ERROR ${end}]"

display_text() {
    cat << "EOF"
      ___   _    _                   ____               _                                      
     / _ \ | |_ | |__    ___  _ __  |  _ \  __ _   ___ | | __ __ _   __ _   ___  ___           
    | | | || __|| '_ \  / _ \| '__| | |_) |/ _` | / __|| |/ // _` | / _` | / _ \/ __|          
    | |_| || |_ | | | ||  __/| |    |  __/| (_| || (__ |   <| (_| || (_| ||  __/\__ \  _  _  _ 
     \___/  \__||_| |_| \___||_|    |_|    \__,_| \___||_|\_\\__,_| \__, | \___||___/ (_)(_)(_)
                                                                    |___/                      
   
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
log="$log_dir/others-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

main_packages=(
  curl
  eog
  fastfetch
  firefox
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
  make
  network-manager-applet
  NetworkManager-tui
  neovim
  nvtop
  pamixer
  pavucontrol
  pipewire-alsa
  pipewire-utils
  polkit-gnome
  python3-requests
  python3-devel
  python3-pip
  python3-pillow
  python3-pyquery
  qt5ct
  qt6ct
  qt6-qtsvg
  ranger
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
)

# other necessary packages
other_packages=(
  btop
  cava
  cliphist
  mpv
  mpv-mpris
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

# installing necessary packages
for packages in "${main_packages[@]}" "${other_packages[@]}" "${thunar[@]}"; do
  install_package "$packages"
  if sudo dnf list installed "$packages" &>> /dev/null; then
    echo "[ DONE ] - $packages was installed successfully!" 2>&1 | tee -a "$log" &>> /dev/null
  else
    echo "[ ERROR ] - Sorry, could not install '$packages'" 2>&1 | tee -a "$log" &>> /dev/null
  fi
done

# installing grimblast
if [ -f '/usr/local/bin/grimblast' ]; then
  printf "${done} - Grimblast is already installed...\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
else

  printf "${action} - Installing grimblast...\n"
  git clone --depth=1 "$grimblast_url" "$parent_dir"/.cache/grimblast/ 2>&1 | tee -a "$log"
  cd "$parent_dir/.cache/grimblast/grimblast"
  make 2>&1 | tee -a "$log"
  sudo make install 2>&1 | tee -a "$log"

  sleep 1
  rm -rf "$parent_dir"/.cache/grimblast 2>&1 | tee -a "$log"
fi

if [ -f '/usr/local/bin/grimblast' ]; then
  printf "${done} - Grimblast was installed successfully...\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

clear
