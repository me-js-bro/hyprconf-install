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

# finding the presend directory and log file
present_dir=`pwd`
# log directory
log_dir="$present_dir/Logs"
log="$log_dir"/sddm.log
mkdir -p "$log_dir"
mkdir -p "$present_dir/.cache"
if [[ ! -f "$log" ]]; then
    touch "$log"
fi

# install script dir
scripts_dir=`dirname "$(realpath "$0")"`
source $scripts_dir/1-global_script.sh

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
  if sudo dnf list installed "$login_manager" &>> /dev/null; then
    echo "Disabling $login_manager..."
    sudo systemctl disable "$login_manager" 2>&1 | tee -a "$log"
  fi
done

printf "${action} - Activating sddm service........\n"
sudo systemctl set-default graphical.target 2>&1 | tee -a "$log"
sudo systemctl enable sddm.service 2>&1 | tee -a "$log"

# Set up SDDM
printf "${action} - Setting up the login screen."
sddm_conf_dir=/etc/sddm.conf.d
[ ! -d "$sddm_conf_dir" ] && { printf "$sddm_conf_dir not found, creating...\n"; sudo mkdir -p "$sddm_conf_dir"; }

clear
    
# SDDM-themes
valid_input=false
while [ "$valid_input" != true ]; do
    printf "${attention} - Installing SDDM Theme\n"

    git clone --depth=1 https://github.com/me-js-bro/sddm.git "$present_dir/.cache/sddm"
    if [[ -d "$present_dir/.cache/sddm" ]]; then
        if [[ -d "/usr/share/sddm/themes/fedora-sddm" ]]; then
        sudo rm -rf "/usr/share/sddm/themes/fedora-sddm"
        printf -e "${done} - Removed existing 'fedora-sddm' directory."
        fi

        # Check if simple-sddm directory exists in the current directory and remove if it does
        if [ ! -d "/usr/share/sddm/themes" ]; then
            sudo mkdir -p /usr/share/sddm/themes
            printf "${done} - Directory '/usr/share/sddm/themes' created."
      fi
      sudo cp -r "$present_dir/.cache/sddm/fedora-sddm" /usr/share/sddm/themes/
      printf "[Theme]\nCurrent=fedora-sddm\n" | sudo tee "$sddm_conf_dir/theme.conf.user"
    fi
    valid_input=true
done

if [[ -d "/usr/share/sddm/themes/fedora-sddm" ]]; then
    printf "${done} - Sddm theme was installed successfully." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    rm -rf "$present_dir/.cache/sddm"
fi

clear