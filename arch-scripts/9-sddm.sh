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

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# log directory
parent_dir="$(dirname "$dir")"
log_dir="$parent_dir/Logs"
log="$log_dir/sddm-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# packages for sddm
sddm=(
  qt6-5compat 
  qt6-declarative 
  qt6-svg
  sddm
)

# Installation of additional sddm stuff
printf "${attention} - Installing sddm and dependencies.... \n"
for sddm_pkgs in "${sddm[@]}"; do
  install_package "$sddm_pkgs"
  if sudo pacman -Qs "$sddm_pkgs" &>> /dev/null; then
        echo "[ DONE ] - $sddm_pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &>> /dev/null
  else
        echo "[ ERROR ] - Sorry, could not install $sddm_pkgs!\n" 2>&1 | tee -a "$log" &>> /dev/null
  fi
done

# Check if other login managers are installed and disabling their service before enabling sddm
for login_manager in lightdm gdm lxdm lxdm-gtk3; do
  if sudo pacman -Qs "$login_manager" &>> /dev/null; then
    echo "Disabling $login_manager..."
    sudo systemctl disable "$login_manager"
  fi
done

printf "${action} - Activating sddm service........\n"
sudo systemctl enable sddm.service

# Set up SDDM
printf "${action} - Setting up the login screen."
sddm_conf_dir=/etc/sddm.conf.d
[ ! -d "$sddm_conf_dir" ] && { printf "$sddm_conf_dir not found, creating...\n"; sudo mkdir -p "$sddm_conf_dir"; }

clear
    
# SDDM-themes
valid_input=false
while [ "$valid_input" != true ]; do
    printf "${attention} - Installing SDDM Theme\n"

    git clone --depth=1 https://github.com/me-js-bro/sddm.git "$parent_dir/.cache/sddm"
    if [[ -d "$parent_dir/.cache/sddm" ]]; then
        # Check if /usr/share/sddm/themes/simple-sddm exists and remove if it does
        if [ -d "/usr/share/sddm/themes/arch-sddm" ]; then
        sudo rm -rf "/usr/share/sddm/themes/arch-sddm"
        printf "${done} - Removed existing 'arch-sddm' directory.\n"
        fi

        # Check if simple-sddm directory exists in the current directory and remove if it does
        if [ ! -d "/usr/share/sddm/themes" ]; then
            sudo mkdir -p /usr/share/sddm/themes
            printf "${done} - Directory '/usr/share/sddm/themes' created.\n"
        fi
      sudo cp -r "$parent_dir/.cache/sddm/arch-sddm" /usr/share/sddm/themes/
      printf "[Theme]\nCurrent=arch-sddm\n" | sudo tee "$sddm_conf_dir/theme.conf.user"
    fi
    valid_input=true
done

if [[ -d "/usr/share/sddm/themes/arch-sddm" ]]; then
    printf "${done} - Sddm theme was installed successfully."
    rm -rf "$parent_dir/.cache/sddm"
fi

clear