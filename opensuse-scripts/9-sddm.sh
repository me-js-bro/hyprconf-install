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

# log directory
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

log_dir="$parent_dir/Logs"
log="$log_dir/sddm-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"
common_scripts="$parent_dir/common"

# packages for sddm
sddm_pkgs=(
  libqt5-qtgraphicaleffects
  libqt5-qtquickcontrols
  libqt5-qtquickcontrols2
  sddm-qt6
  xauth
  xf86-input-evdev
  xorg-x11-server
)

# Install SDDM 
printf "${action}\n==> Installing packages for sddm\n"
for sddm in "${sddm_pkgs[@]}" ; do
  install_package_no_recommands "$sddm"
    if sudo zypper se -i "$sddm" &>> /dev/null ; then
        echo "[ DONE ] - $sddm was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Could not install $sddm..." 2>&1 | tee -a "$log" &> /dev/null
    fi
done

# Check if other login managers are installed and disabling their service before enabling sddm
for login_manager in lightdm gdm lxdm lxdm-gtk3; do
  if sudo  zypper se -i "$login_manager" &>> /dev/null; then
    printf "${attention}\n:: Disabling $login_manager\n"
    sudo systemctl disable "$login_manager" 2>&1 | tee -a "$log"
  fi
done

# activation of sddm service
printf "${action}\n==> Activating login manager (sddm)\n"
sudo systemctl set-default graphical.target 2>&1 | tee -a "$log"
sudo update-alternatives --set default-displaymanager /usr/lib/X11/displaymanagers/sddm 2>&1 | tee -a "$log"
sudo systemctl enable sddm.service 2>&1 | tee -a "$log"

# run sddm theme script
"$common_scripts/sddm_theme.sh"