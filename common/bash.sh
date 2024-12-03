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
   ___           __ 
  / _ )___ ____ / / 
 / _  / _ `(_-</ _ \
/____/\_,_/___/_//_/
                     
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
log="$log_dir/bash-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# check if there is a .bash directory available. if available, then backup it.
if [ -d ~/.bash ]; then
    printf "${note}\n:: A ${green}.bash${end} directory is available. Backing it up\n" && sleep 1

    cp -r ~/.bash ~/.bash-${USER} 2>&1 | tee -a "$log"
    fn_done "Backe up."
fi

bash <(curl https://raw.githubusercontent.com/me-js-bro/Bash/main/direct_install.sh) 2>&1 | tee -a "$log"