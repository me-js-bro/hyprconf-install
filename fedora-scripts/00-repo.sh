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
        --width 60 \
        --margin "1" \
        --padding "1" \
'
   ___                    _ __           _       
  / _ \___ ___  ___  ___ (_) /____  ____(_)__ ___
 / , _/ -_) _ \/ _ \(_-</ / __/ _ \/ __/ / -_|_-<
/_/|_|\__/ .__/\___/___/_/\__/\___/_/ /_/\__/___/
        /_/                                       
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
log="$log_dir/copr-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# List of COPR repositories to be added and enabled
copr_repos=(
  solopasha/hyprland
  erikreider/SwayNotificationCenter
  tofik/nwg-shell
)

# Function to add dnf config if not present in a file
add_config_if_not_present() {
  local file="$1"
  local config="$2"
  grep -qF "$config" "$file" || echo "$config" | sudo tee -a "$file" &>> /dev/null
}

fn_ask "Have you added 'fastestmirrors=True' & 'max_paralled_downloads=10' in your dnf.conf file?"

if [[ $? -eq 1 ]]; then
    # Check and add configuration settings to /etc/dnf/dnf.conf
    add_config_if_not_present "/etc/dnf/dnf.conf" "max_parallel_downloads=5" 2>&1 | tee -a "$log"
    add_config_if_not_present "/etc/dnf/dnf.conf" "fastestmirrors=True" 2>&1 | tee -a "$log"
    add_config_if_not_present "/etc/dnf/dnf.conf" "defaultyes=True" 2>&1 | tee -a "$log"
fi

# enabling 3rd party repo
install_package https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 2>&1 | tee -a "$log" &&


# Enable COPR Repositories 
for repo in "${copr_repos[@]}";do 
  sudo dnf copr enable -y "$repo" 2>&1 | tee -a "$log" || { printf "${error}\n! Failed to enable necessary copr repos (╥﹏╥)\n"; exit 1; }
done
