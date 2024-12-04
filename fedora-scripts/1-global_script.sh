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


dir="$(dirname "$(realpath "$0")")"
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"


###------ Startup ------###

# package installation function..
install_package() {

# Checking if package is already installed
if sudo dnf list installed "$1" &>> /dev/null ; then
    fn_done "$1 is already installed. Skipping."
else

    printf "${action}\n==> Installing $1."
    sudo dnf install -y "$1"
    
    if sudo dnf list installed "$1" &>> /dev/null ; then
      fn_done " $1 was installed successfully!"
    else
    
      fn_error "$1 failed to install. Maybe there was an issue. (╥﹏╥)"
    fi
  fi
}