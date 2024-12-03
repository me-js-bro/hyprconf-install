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
   ___       __  ____ __      
  / _ \___  / /_/ _(_) /__ ___
 / // / _ \/ __/ _/ / / -_|_-<
/____/\___/\__/_//_/_/\__/___/
                               
'
}

clear && display_text
printf " \n \n"

###------ Startup ------###

dir="$(dirname "$(realpath "$0")")"
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

cache_dir="$parent_dir/.cache"
distro_cache="$cache_dir/distro"
source "$distro_cache"

# install script dir
source "$parent_dir/${distro}-scripts/1-global_script.sh"

# log directory
log_dir="$parent_dir/Logs"
log="$log_dir/dotfiles-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# _______ Testing _______ #

fn_action "Clonning the dotfiles repository and setting it to your system." "1"
# Create the cache directory if it doesn't exist
mkdir -p "$cache_dir"

# Clone the repository and log the output
if [[ ! -d "$cache_dir/hyprconf" ]]; then
  git clone --depth=1 https://github.com/me-js-bro/hyprconf.git "$cache_dir/hyprconf" 2>&1 | tee -a "$log"
fi

sleep 1

# if repo clonned successfully, then setting up the config
if [[ -d "$cache_dir/hyprconf" ]]; then
  cd "$cache_dir/hyprconf" || { printf "${error}\n! Could not changed directory to $cache_dir/hyprconf (╥﹏╥)\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }

  chmod +x setup.sh
  
  ./setup.sh || { printf "${error}\n! Could not run the setup script for hyprconf (╥﹏╥)\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }
fi

if [[ -f "$HOME/.config/hypr/scripts/startup.sh" ]]; then
  printf "${done}\n:: Dotfiles setup was successful.!\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
else
  printf "${error}\n! Could not setup dotfiles. Maybe there was an error. Please check the ${green}'$log'${end} file. (╥﹏╥)\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
  exit 1
fi

sleep 1 && clear