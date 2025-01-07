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

display_text() {
    gum style \
        --border rounded \
        --align center \
        --width 60 \
        --margin "1" \
        --padding "1" \
'
 ____  ______ __
/_  / / __/ // /
 / /__\ \/ _  / 
/___/___/_//_/  
                
                               
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

log_dir="$parent_dir/Logs"
log="$log_dir/zsh-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# check if there is a .bash directory available. if available, then backup it.
if [ -d ~/.zsh ]; then
    msg nt "A ${green}.zsh${end} directory is available. Backing it up.." && sleep 1

    mv ~/.zsh ~/.zsh-${USER} 2>&1 | tee -a "$log"
    msg dn "Successfully backed up .zsh"
fi

# now install bash

if [[ ! -d "$parent_dir/.cache/Zsh" ]]; then
    git clone --depth=1 https://github.com/me-js-bro/Zsh.git "$parent_dir/.cache/Zsh" 2>&1 | tee -a "$log" && sleep 1 &> /dev/null
fi

if [[ -d "$parent_dir/.cache/Zsh" ]]; then
    cd "$parent_dir/.cache/Zsh" || msg err "Could not cd into $parent_dir/.cache/Zsh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    chmod +x install.sh 2>&1 | tee -a "$log"
    ./install.sh 2>&1 | tee -a "$log"
    exit 0
else
    msg err "Could not fine $pare nt_dir/.cache/Zsh. exiting.."
    exit 1
fi

clear
