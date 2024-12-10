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
  fastfetch
  git
  gnome-disk-utility
  go1.23
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
  mate-polkit
  make
  neovim
  pamixer
  pavucontrol
  pipewire-alsa
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
  yazi
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


# installing necessary packages
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
  fn_done "Grimblast is already installed.."
  echo "[ DONE ] - Grimblast is already installed" 2>&1 | tee -a  "$log" &> /dev/null
else

  printf "${action}\n==> Installing grimblast\n"
  git clone --depth=1 "$grimblast_url" ~/grimblast
  cd "$HOME/grimblast/grimblast"
  make
  sudo make install

  sleep 1
  rm -rf ~/grimblast
  fn_done "Grimblast was installed successfully!"
  echo "[ DONE ] - Grimblast was installed successfully!" 2>&1 | tee -a  "$log" &> /dev/null
fi

sleep 2 && clear

# Install cliphist using go
if command -v go &> /dev/null; then
  printf "${action}\n==> Installing cliphist\n"
  export PATH=$PATH:/usr/local/bin

  if go install go.senan.xyz/cliphist@latest 2>&1 | tee -a "$log" &> /dev/null; then
    # copy cliphist into /usr/local/bin for some reason it is installing in ~/go/bin
    sudo cp -r "$HOME/go/bin/cliphist" "/usr/local/bin/" 2>&1 | tee -a "$log" &> /dev/null
    fn_done "Cliphist was installed successfully!"
    echo "[ DONE ] - Cliphist was installed successfully!" 2>&1 | tee -a  "$log" &> /dev/null

    sudo rm -rf "$HOME/go"
  else
    fn_error "Could not install cliphist. (╥﹏╥)"
    echo "[ ERROR ] - Could not install cliphist. (╥﹏╥)" 2>&1 | tee -a "$log" &> /dev/null
  fi
fi

sleep 2 && clear

chmod +x "$dir/pywal.sh"
"$dir/pywal.sh"

