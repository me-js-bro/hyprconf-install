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

# finding the presend directory and log file
present_dir=`pwd`
# log directory
log_dir="$present_dir/Logs"
log="$log_dir"/copr-repo.log
mkdir -p "$log_dir"
if [[ ! -f "$log" ]]; then
    touch "$log"
fi

# List of COPR repositories to be added and enabled
copr_repos=(
solopasha/hyprland
erikreider/SwayNotificationCenter  
)

# Function to add dnf config if not present in a file
add_config_if_not_present() {
  local file="$1"
  local config="$2"
  grep -qF "$config" "$file" || echo "$config" | sudo tee -a "$file" &>> /dev/null
}

printf "${attention} - Have you added 'fastestmirrors=True' & 'max_paralled_downloads=10' in your dnf.conf file? [ y/n ] \n"
read -p "Select: " config

if [[ "$config" =~ ^[Nn]$ ]]; then
    # Check and add configuration settings to /etc/dnf/dnf.conf
    add_config_if_not_present "/etc/dnf/dnf.conf" "max_parallel_downloads=5"
    add_config_if_not_present "/etc/dnf/dnf.conf" "fastestmirrors=True"
    add_config_if_not_present "/etc/dnf/dnf.conf" "defaultyes=True"
fi

# enabling 3rd party repo
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm &&


# Enable COPR Repositories 
for repo in "${copr_repos[@]}";do 
  sudo dnf copr enable -y "$repo" 2>&1 | tee -a "$log" || { printf "${error} - Failed to enable necessary copr repos\n"; exit 1; }
done

# clear
