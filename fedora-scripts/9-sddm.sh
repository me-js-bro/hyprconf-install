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
     ____       _      _                      
    / ___|   __| |  __| | _ __ ___            
    \___ \  / _` | / _` || '_ ` _ \           
     ___) || (_| || (_| || | | | | |  _  _  _ 
    |____/  \__,_| \__,_||_| |_| |_| (_)(_)(_)
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# present dir


# log directory
parent_dir="$(dirname "$dir")"
log_dir="$parent_dir/Logs"
log="$log_dir/sddm-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"
common_scripts="$parent_dir/common"

# packages for sddm
sddm=(
    sddm
    qt6-qt5compat 
    qt6-qtdeclarative 
    qt6-qtsvg
)

# Installation of additional sddm stuff
printf "${attention} - Installing sddm and dependencies.... \n"
for sddm_pkgs in "${sddm[@]}"; do
  install_package "$sddm_pkgs"
  if sudo dnf list installed "$sddm_pkgs" &>> /dev/null; then
    printf "${done} - $sddm_pkgs was installed successfully..\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
  else
    printf "${error} - Sorry, could not install $sddm_pkgs\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
  fi
done

# Check if other login managers are installed and disabling their service before enabling sddm
for login_manager in lightdm gdm lxdm lxdm-gtk3; do
  if sudo dnf list installed "$login_manager" &> /dev/null; then
    echo "Disabling $login_manager..."
    sudo systemctl disable "$login_manager" 2>&1 | tee -a "$log"
  fi
done

printf "${action} - Activating sddm service........\n"
sudo systemctl set-default graphical.target 2>&1 | tee -a "$log"
sudo systemctl enable sddm.service 2>&1 | tee -a "$log"

# run sddm theme script
"$common_scripts/sddm_theme.sh"