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

# packages neeeded
hypr_package=( 
  alacritty
  curl
  ffmpeg
  firefox
  fastfetch
  git
  grim
  ImageMagick
  jq
  kvantum-qt5
  kvantum-qt6
  kvantum-themes
  kvantum-manager
  libnotify-tools
  lxappearance
  make
  neovim
  pamixer
  pavucontrol
  pipewire-alsa
  polkit-gnome
  python311-requests
  python311-pip
  python311-pywal
  qt5ct
  qt6ct
  qt6-svg-devel
  libqt5-qtquickcontrols
  libqt5-qtquickcontrols2
  libqt5-qtgraphicaleffects
  rofi-wayland
  slurp
  SwayNotificationCenter
  swappy
  swww
  tar
  unzip
  wayland-protocols-devel
  wget
  wl-clipboard
  xdg-utils
  xwayland
  yad
)

other_packages=(
  btop
  cava
  mousepad
  mpv
  mpv-mpris
  nvtop
)

# no recommands
no_recommands=(
  eog
  NetworkManager-applet
  waybar
)

# opi
opi_packages=(
  nwg-look
)

# forcd install
cliphist=(
  go
)

# thunar
thunar=(
ffmpegthumbnailer
file-roller
thunar 
thunar-volman 
tumbler 
thunar-plugin-archive
)

grimblast_url=https://github.com/hyprwm/contrib.git


# Installation of main components
printf "${action} - Installing hyprland packages.... \n"

for packages in "${hypr_package[@]}" "${other_packages[@]}"; do
  install_package "$packages"
    if sudo zypper se -i "$packages" &> /dev/null ; then
        echo "[ DONE ] - $packages was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Could not install $packages..." 2>&1 | tee -a "$log" &> /dev/null
    fi
done

# installing swaylock-effects & nwg-look
for opi_pkg in "${opi_packages[@]}"; do
  install_package_opi "$opi_pkg"
    if sudo zypper se -i "$opi_pkg" &> /dev/null ; then
        echo "[ DONE ] - $opi_pkg was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Could not install $opi_pkg..." 2>&1 | tee -a "$log" &> /dev/null
    fi
done

# installing thunar
for pkgs in "${no_recommands[@]}" "${thunar[@]}"; do
  install_package_no_recommands "$pkgs"
    if sudo zypper se -i "$pkgs" &> /dev/null ; then
        echo "[ DONE ] - $pkgs was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Could not install $pkgs..." 2>&1 | tee -a "$log" &> /dev/null
    fi
done

# installing forcefully
for force_inst in "${cliphist[@]}"; do
  sudo zypper in -f -y "$force_inst"
    if sudo zypper se -i "$force_inst" &> /dev/null ; then
        echo "[ DONE ] - $force_inst was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Could not install $force_inst..." 2>&1 | tee -a "$log" &> /dev/null
    fi
done

# installing grimblast
if [ -f '/usr/local/bin/grimblast' ]; then
  printf "${done} - Grimblast is already installed...\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
else

  printf "${attention} - Cloning grimblast grom github to install for screenshot...\n"
  git clone --depth=1 "$grimblast_url" ~/grimblast
  cd "$HOME/grimblast/grimblast"
  make
  sudo make install

  sleep 1
  rm -rf ~/grimblast
  printf "${done} - Grimblast was installed successfully\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi


# Install cliphist using go
export PATH=$PATH:/usr/local/bin
go install go.senan.xyz/cliphist@latest 2>&1 | tee -a "$log" &> /dev/null

# copy cliphist into /usr/local/bin for some reason it is installing in ~/go/bin
sudo cp -r "$HOME/go/bin/cliphist" "/usr/local/bin/" 2>&1 | tee -a "$log" &> /dev/null

clear