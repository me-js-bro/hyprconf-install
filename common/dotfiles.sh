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
   ____          _    _____  _  _                      
  |  _ \   ___  | |_ |  ___|(_)| |  ___  ___           
  | | | | / _ \ | __|| |_   | || | / _ \/ __|          
  | |_| || (_) || |_ |  _|  | || ||  __/\__ \  _  _  _ 
  |____/  \___/  \__||_|    |_||_| \___||___/ (_)(_)(_)

EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###


# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# present dir

cache_dir="$parent_dir/.cache"

# log directory
parent_dir="$(dirname "$dir")"
log_dir="$parent_dir/Logs"
log="$log_dir/vs_code-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# _______ Testing _______ #

printf "${attention} - Clonning the dotfiles repository and setting it to your system..\n"
sleep 1
# Create the cache directory if it doesn't exist
mkdir -p "$cache_dir"

# Clone the repository and log the output
git clone --depth=1 https://github.com/me-js-bro/hyprconf.git "$cache_dir/hyprconf" 2>&1 | tee -a "$log"

sleep 1

# if repo clonned successfully, then setting up the config
if [[ -d "$cache_dir/hyprconf" ]]; then
  cd "$cache_dir/hyprconf" || { printf "${error} - Could not changed directory to $cache_dir/hyprconf\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }

  chmod +x setup.sh
  
  ./setup.sh || { printf "${error} - Could not run the setup script for hyprconf\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }
fi

if [[ -f "$HOME/.config/hypr/scripts/startup.sh" ]]; then
  printf "${done} - Dotfiles setup was successful.!\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
  clear
else
  printf "${error} - Could not setup dotfiles. Maybe there was an error. Please check the ${green}'$log'${end} file.\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
  exit 1
fi
