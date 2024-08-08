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
     ____                   ____                                
    / ___|___  _ __  _ __  |  _ \ ___ _ __   ___                
   | |   / _ \| '_ \| '__| | |_) / _ \ '_ \ / _ \               
   | |__| (_) | |_) | |    |  _ <  __/ |_) | (_) |  _   _   _   
    \____\___/| .__/|_|    |_| \_\___| .__/ \___/  (_) (_) (_)  
              |_|                    |_|                        
   
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
log="$log_dir/repo-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# packman repository
packman_repo="https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/"

dependencies=(
  devel_basis
)

opi=(
  opi
  go
)

# Adding Packman repository and switching over to Packman
printf "${attention} - Adding Packman repository (Globally).... \n"

sudo zypper -n --quiet ar --refresh -p 90 "$packman_repo" packman 2>&1 | tee -a "$log"
sudo zypper --gpg-auto-import-keys refresh 2>&1 | tee -a "$log"
sudo zypper -n dup --from packman --allow-vendor-change 2>&1 | tee -a "$log"

for deps in "${dependencies[@]}"; do
    install_package_base "$deps"
    if sudo zypper se -i "$deps" &>> /dev/null ; then
      echo "[ DONE ] - '$deps' was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Sorry, could not install '$deps'" 2>&1 | tee -a "$log" &> /dev/null
    fi
done

for opis in "${opi[@]}"; do
    install_package "$opis"
    if sudo zypper se -i "$opis" &>> /dev/null ; then
      echo "[ DONE ] - '$opis' was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Sorry, could not install '$opis'" 2>&1 | tee -a "$log" &> /dev/null
    fi
done

clear
