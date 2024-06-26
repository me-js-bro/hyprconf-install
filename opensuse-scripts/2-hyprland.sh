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
     _   _                      _                    _           
    | | | | _   _  _ __   _ __ | |  __ _  _ __    __| |          
    | |_| || | | || '_ \ | '__|| | / _` || '_ \  / _` |          
    |  _  || |_| || |_) || |   | || (_| || | | || (_| |  _  _  _ 
    |_| |_| \__, || .__/ |_|   |_| \__,_||_| |_| \__,_| (_)(_)(_)
            |___/ |_|                                            
   
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# finding the presend directory and log file
present_dir=`pwd`
# log directory
log_dir="$present_dir/Logs"
log="$log_dir"/hyprland.log
mkdir -p "$log_dir"
if [[ ! -f "$log" ]]; then
    touch "$log"
fi

# install script dir
scripts_dir=`dirname "$(realpath "$0")"`
source $scripts_dir/1-global_script.sh

# Hyprland
printf "${action} - Installing Hyprland...\n"
  install_package hyprland
    if sudo zypper se -i hyprland &>> /dev/null ; then
        echo "[ DONE ] - Hyprland was installed successfully!" 2>&1 | tee -a "$log" &>> /dev/null
    else
        echo "[ ERROR ] - Could not install Hyprland..." 2>&1 | tee -a "$log" &>> /dev/null
    fi
    
# Hyprlock
printf "${action} - Installing Hyprlock...\n"
  install_package_opi hyprlock
    if sudo zypper se -i hyprlock &>> /dev/null ; then
        echo "[ DONE ] - Hyprland was installed successfully!" 2>&1 | tee -a "$log" &>> /dev/null
    else
        echo "[ ERROR ] - Could not install Hyprland..." 2>&1 | tee -a "$log" &>> /dev/null
    fi

clear

# Hyprpaper
printf "${action} - Installing Hyprlock...\n"
  install_package_opi hyprpaper
    if sudo zypper se -i hyprpaper &>> /dev/null ; then
        echo "[ DONE ] - Hyprland was installed successfully!" 2>&1 | tee -a "$log" &>> /dev/null
    else
        echo "[ ERROR ] - Could not install Hyprland..." 2>&1 | tee -a "$log" &>> /dev/null
    fi

clear
