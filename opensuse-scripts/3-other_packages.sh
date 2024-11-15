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

# packages neeeded
hypr_package=( 
  curl
  ffmpeg
  firefox
  fastfetch
  git
  gnome-disk-utility
  grim
  ImageMagick
  jq
  kitty
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
  python312-requests
  python312-pip
  python312-pipx
  qt5ct
  qt6ct
  qt6-svg-devel
  libqt5-qtquickcontrols
  libqt5-qtquickcontrols2
  libqt5-qtgraphicaleffects
  nwg-look
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
  mpv
  mpv-mpris
  nvtop
)

# no recommands
no_recommands=(
  eog
  go
  NetworkManager-applet
  waybar
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

# installing thunar
for pkgs in "${no_recommands[@]}" "${thunar[@]}"; do
  install_package_no_recommands "$pkgs"
    if sudo zypper se -i "$pkgs" &> /dev/null ; then
        echo "[ DONE ] - $pkgs was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Could not install $pkgs..." 2>&1 | tee -a "$log" &> /dev/null
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

sleep 1 && clear

# Install cliphist using go
if [ -n "$command -v go" ]; then
  printf "${action} - Installing cliphist\n"
  export PATH=$PATH:/usr/local/bin

  if go install go.senan.xyz/cliphist@latest 2>&1 | tee -a "$log" &> /dev/null; then
    # copy cliphist into /usr/local/bin for some reason it is installing in ~/go/bin
    sudo cp -r "$HOME/go/bin/cliphist" "/usr/local/bin/" 2>&1 | tee -a "$log" &> /dev/null
    printf "${done} - Successfully installed cliphist!\n" 2>&1 | tee -a "$log"
    sudo rm -rf "$HOME/go"
  else
    printf "${error} - Could not install cliphist.\n" 2>&1 | tee -a "$log"
  fi
fi

sleep 1 && clear


# installing pywal
if [ -n "$(command -v pipx)" ]; then
  printf "${action} - Installing pywal using ${green}'pipx'${end}\n"
  if pipx install pywal; then
    printf "${done} - pywal was install successfully\n" 2>&1 | tee -a "$log"
  else
    printf "${erorr} - Sorry, could not install pywal. You need to install it manually. :(\n" 2>&1 | tee -a "$log"
  fi
fi