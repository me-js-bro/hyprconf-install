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

# present dir


# log directory
parent_dir="$(dirname "$dir")"
log_dir="$parent_dir/Logs"
log="$log_dir/sddm-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

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
printf "${action} - Installing sddm and dependencies.... \n"
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
    printf "${attention} - Disabling $login_manager\n"
    sudo systemctl disable "$login_manager" 2>&1 | tee -a "$log"
  fi
done

# activation of sddm service
printf "${action} - Activating sddm service........\n"
sudo systemctl set-default graphical.target 2>&1 | tee -a "$log"
sudo update-alternatives --set default-displaymanager /usr/lib/X11/displaymanagers/sddm 2>&1 | tee -a "$log"
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

    git clone --depth=1 https://github.com/me-js-bro/sddm.git "$parent_dir/.cache/sddm"
    if [[ -d "$parent_dir/.cache/sddm" ]]; then
        if [[ -d "/usr/share/sddm/themes/opensuse-sddm" ]]; then
        sudo rm -rf "/usr/share/sddm/themes/opensuse-sddm"
        printf -e "${done} - Removed existing 'opensuse-sddm' directory."
        fi

        # Check if simple-sddm directory exists in the current directory and remove if it does
        if [ ! -d "/usr/share/sddm/themes" ]; then
            sudo mkdir -p /usr/share/sddm/themes
            printf "${done} - Directory '/usr/share/sddm/themes' created."
      fi
      sudo cp -r "$parent_dir/.cache/sddm/opensuse-sddm" /usr/share/sddm/themes/
      printf "[Theme]\nCurrent=opensuse-sddm\n" | sudo tee "$sddm_conf_dir/theme.conf.user"
    fi
    valid_input=true
done

if [[ -d "/usr/share/sddm/themes/opensuse-sddm" ]]; then
    printf "${done} - Sddm theme was installed successfully." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    rm -rf "$parent_dir/.cache/sddm"
fi