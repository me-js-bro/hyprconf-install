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
      ___                       ____                        _                  
     / _ \  _ __    ___  _ __  | __ )   __ _  _ __    __ _ | |  __ _           
    | | | || '_ \  / _ \| '_ \ |  _ \  / _` || '_ \  / _` || | / _` |          
    | |_| || |_) ||  __/| | | || |_) || (_| || | | || (_| || || (_| |  _  _  _ 
     \___/ | .__/  \___||_| |_||____/  \__,_||_| |_| \__, ||_| \__,_| (_)(_)(_)
           |_|                                       |___/                                             
        
EOF
}

clear && display_text
printf " \n \n"

# install script dir
dir="$(dirname "$(realpath "$0")")"

# log directory
parent_dir="$(dirname "$dir")"
log_dir="$parent_dir/Logs"
log="$log_dir/openbangla-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"


###------ Startup ------###

printf "${attention} - This script will creand a Log dir in your ${HOME} directory. Please remove that Log dir after you finish the script \n"
sleep 1

# OpenBangla-Building url was forked from ( https://github.com/asifakonjee/openbangla-fcitx5 )
inst_openbangla_cmd=$(wget -q https://raw.githubusercontent.com/me-js-bro/Build-OpenBangla-Keyboard/main/build.sh -O -)

bash -c "$inst_openbangla_cmd"

if [[ -d "/usr/share/openbangla-keyboard" ]]; then
  printf "${done} - OpenBangla Keyboard was installed successfully!\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi