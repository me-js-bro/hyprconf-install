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


###------ Startup ------###

# finding the presend directory
present_dir=`pwd`
# log directory
log_dir="$present_dir/Logs"
log="$log_dir"/global.log
mkdir -p "$log_dir"
if [[ ! -f "$log" ]]; then
    touch "$log"
fi

# package installation function..
install_package() {

# Checking if package is already installed
if sudo dnf list installed "$1" &>> /dev/null ; then
    printf "${done} - $1 is already installed. Skipping...\n"
else
    # Package not installed
    printf "${action} - Installing $1 ...\n"
    sudo dnf install -y "$1"
    # Making sure package is installed
    if sudo dnf list installed "$1" &>> /dev/null ; then
      printf "${done} - $1 was installed successfully!\n \n"
    else
      # Something is missing, exiting to review log
      printf "${error} - $1 failed to install :( , please check the install.log .Maybe you may need to install manually.\n"
      # exit 1
    fi
  fi
}