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
  ____                ___                 __    
 / __ \___  ___ ___  / _ )___ ____  ___ _/ /__ _
/ /_/ / _ \/ -_) _ \/ _  / _ `/ _ \/ _ `/ / _ `/
\____/ .__/\__/_//_/____/\_,_/_//_/\_, /_/\_,_/ 
    /_/                           /___/         
                               
'
}

clear && display_text
printf " \n \n"

# install script dir
dir="$(dirname "$(realpath "$0")")"

# log directory
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

log_dir="$parent_dir/Logs"
log="$log_dir/openbangla-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"


###------ Startup ------###

printf "${attention}\n==> This script will creand a Log dir in your ${HOME} directory. Please remove that Log dir after you finish the script.\n"
sleep 1

# OpenBangla-Building url was forked from ( https://github.com/asifakonjee/openbangla-fcitx5 )
bash -c "$(wget -q https://raw.githubusercontent.com/me-js-bro/Build-OpenBangla-Keyboard/main/build.sh -O -)"

if [[ -d "/usr/share/openbangla-keyboard" ]]; then
  fn_done "OpenBangla Keyboard was installed successfully!\n"
  echo "[ DONE ] - OpenBangla Keyboard was installed successfully!" 2>&1 | tee -a "$log"
fi

sleep 1 && clear