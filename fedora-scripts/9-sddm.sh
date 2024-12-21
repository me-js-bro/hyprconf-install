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
   _______  ___  __  ___
  / __/ _ \/ _ \/  |/  /
 _\ \/ // / // / /|_/ / 
/___/____/____/_/  /_/   

'
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# present dir
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

# log directory
log_dir="$parent_dir/Logs"
log="$log_dir/sddm-$(date +%d-%m-%y).log"

if [[ -f "$log" ]]; then
    errors=$(grep "ERROR" "$log")
    last_installed=$(grep "qt6-qtsvg" "$log" | awk {'print $2'})
    if [[ -z "$errors" && "$last_installed" == "DONE" ]]; then
        printf "${note}\n;; No need to run this script again\n"
        sleep 2
        exit 0
    fi
else
    mkdir -p "$log_dir"
    touch "$log"
fi

common_scripts="$parent_dir/common"

# packages for sddm
sddm=(
    qt5-qtgraphicaleffects
    qt5-qtquickcontrols
    sddm
    qt6-qt5compat 
    qt6-qtdeclarative 
    qt6-qtsvg
)

# Installation of additional sddm stuff
printf "${action}\n==> Installing sddm and dependencies.\n"
for sddm_pkgs in "${sddm[@]}"; do
  install_package "$sddm_pkgs"
  if sudo dnf list installed "$sddm_pkgs" &> /dev/null; then
    printf "${done}\n:: $sddm_pkgs was installed successfully.\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
  else
    printf "${error}\n! Sorry, could not install $sddm_pkgs (╥﹏╥)\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    exit 1
  fi
done

# Check if other login managers are installed and disabling their service before enabling sddm
for login_manager in lightdm gdm lxdm lxdm-gtk3; do
  if sudo dnf list installed "$login_manager" &> /dev/null; then
    echo "Disabling $login_manager..."
    sudo systemctl disable "$login_manager" 2>&1 | tee -a "$log"
  fi
done

printf "${action}\n==> Activating sddm service.\n"
sudo systemctl set-default graphical.target 2>&1 | tee -a "$log"
sudo systemctl enable sddm.service 2>&1 | tee -a "$log"

sleep 1 && clear

printf "${action}\n==> Cloning sddm theme for fedora.\n"
git clone --depth=1 https://github.com/me-js-bro/sddm "$parent_dir/.cache/sddm"

if [[ -d "$parent_dir/.cache/sddm" ]]; then
  sudo cp -r "$parent_dir/.cache/sddm/fedora-sddm" "/usr/share/sddm/themes/"
fi

if [[ -d "/usr/share/sddm/themes/fedora-sddm" ]]; then
  printf "${action}\n==> Setting up the Login Screen.\n"
  sddm_conf_dir=/etc/sddm.conf.d
  [ ! -d "$sddm_conf_dir" ] && { printf "$sddm_conf_dir not found, creating...\n"; sudo mkdir -p "$sddm_conf_dir"; }
  echo -e "[Theme]\nCurrent=fedora-sddm" | sudo tee "$sddm_conf_dir/theme.conf.user" &> /dev/null
else
  printf "${error}\n!! Sorry, could not set the login theme.\n"
fi
