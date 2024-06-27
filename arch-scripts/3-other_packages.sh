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
      ___   _    _                   ____               _                                      
     / _ \ | |_ | |__    ___  _ __  |  _ \  __ _   ___ | | __ __ _   __ _   ___  ___           
    | | | || __|| '_ \  / _ \| '__| | |_) |/ _` | / __|| |/ // _` | / _` | / _ \/ __|          
    | |_| || |_ | | | ||  __/| |    |  __/| (_| || (__ |   <| (_| || (_| ||  __/\__ \  _  _  _ 
     \___/  \__||_| |_| \___||_|    |_|    \__,_| \___||_|\_\\__,_| \__, | \___||___/ (_)(_)(_)
                                                                    |___/                      
   
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# finding the presend directory and log file
present_dir=`pwd`
# log directory
log_dir="$present_dir/Logs"
log="$log_dir"/other-packages.log
mkdir -p "$log_dir"
if [[ ! -f "$log" ]]; then
    touch "$log"
fi

# install script dir
scripts_dir=`dirname "$(realpath "$0")"`
source $scripts_dir/1-global_script.sh

# any other packages will be installed from here
other_packages=(
    btop
    brightnessctl
    curl
    fastfetch
    firefox
    ffmpeg
    ibus
    imagemagick
    jq
    kvantum
    lxappearance
    network-manager-applet
    networkmanager
    ntfs-3g
    nvtop
    os-prober
    pacman-contrib
    pamixer
    pavucontrol
    python-pywal
    wget
    yad
)

printf "${action} - Now installing some necessary packages...\n" && sleep 1
printf " \n"

for other_pkgs in "${other_packages[@]}"; do
    install_package "$other_pkgs"
    if sudo pacman -Qs "$other_pkgs" &>> /dev/null; then
        echo "[ DONE ] - $other_pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &>> /dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $other_pkgs!\n" 2>&1 | tee -a "$log" &>> /dev/null
    fi
done