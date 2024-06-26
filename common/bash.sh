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
     ____               _               
    | __ )   __ _  ___ | |__            
    |  _ \  / _` |/ __|| '_ \           
    | |_) || (_| |\__ \| | | |  _  _  _ 
    |____/  \__,_||___/|_| |_| (_)(_)(_)                                    
                                     
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# finding the presend directory and log file
present_dir=`pwd`
# log directory
log_dir="$present_dir/Logs"
log="$log_dir"/bash.log
mkdir -p "$log_dir"
if [[ ! -f "$log" ]]; then
    touch "$log"
fi

# check if there is a .bash directory available. if available, then backup it.
if [ -d ~/.bash ]; then
    printf "${note} - A ${green}.bash${end} directory is available... Backing it up\n" && sleep 1

    cp -r ~/.bash ~/.bash-${USER} 2>&1 | tee -a "$log"
    printf "${done} - Backup done..\n \n"
fi

# now install bash

git clone --depth=1 https://github.com/me-js-bro/Bash.git "$present_dir/.cache/Bash" && sleep 1
cd "$present_dir/.cache/Bash"
chmod +x install.sh
./install.sh

clear