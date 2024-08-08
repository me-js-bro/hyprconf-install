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
   _____      _               
  |__  / ___ | |__            
    / / / __|| '_ \           
   / /_ \__ \| | | |  _  _  _ 
  /____||___/|_| |_| (_)(_)(_)
   
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

dir="$(dirname "$(realpath "$0")")"
parent_dir="$(dirname "$dir")"
cache_dir="$parent_dir/.cache"
distro_cache="$cache_dir/distro"
source "$distro_cache"

# install script dir
source "$parent_dir/${distro}-scripts/1-global_script.sh"

log_dir="$parent_dir/Logs"
log="$log_dir/zsh-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# check if there is a .bash directory available. if available, then backup it.
if [ -d ~/.zsh ]; then
    printf "${note} - A ${green}.zsh${end} directory is available... Backing it up\n" && sleep 1

    cp -r ~/.zsh ~/.zsh-${USER} 2>&1 | tee -a "$log"
    printf "${done} - Backup done..\n \n"
fi

# now install bash

if [[ ! -d "$parent_dir/.cache/Zsh" ]]; then
    git clone --depth=1 https://github.com/me-js-bro/Zsh.git "$parent_dir/.cache/Zsh" 2>&1 | tee -a "$log" && sleep 1
fi

if [[ -d "$parent_dir/.cache/Zsh" ]]; then
    cd "$parent_dir/.cache/Zsh" || printf "${error } - Could not cd into $parent_dir/.cache/Zsh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    chmod +x install.sh 2>&1 | tee -a "$log"
    ./install.sh 2>&1 | tee -a "$log"
    exit 0
else
    printf "${error} - Could not fine $parent_dir/.cache/Zsh. exiting \n"
    exit 1
fi

# clear