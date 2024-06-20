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

package_manager=$(command -v pacman || command -v yay || command -v paru)
aur_helper=$(command -v yay || command -v paru) # find the aur helper

# package installation from main repo function..
install_package() {
 
  # Checking if package is already installed
  if sudo "$package_manager" -Qs "$1" &>> /dev/null ; then
    printf "${done} - $1 is already installed. Skipping...\n\n"
  else
    # Package not installed
    printf "${action} - Installing $1 ...\n"
    sudo pacman -S --noconfirm
    # Making sure package is installed
    if sudo "$package_manager" -Qs "$1" &>> /dev/null ; then
      printf "${done} - $1 was installed successfully!\n\n"
    else
      # Something is missing, exiting to review log
      printf "${error} - $1 failed to install :( , please check the install.log .Maybe you may need to install manually.\n"
    fi
  fi
}

# package installation from aur helper function..
install_from_aur() {

  # Checking if package is already installed
  if sudo "$package_manager" -Qs "$1" &>> /dev/null ; then
    printf "${done} - $1 is already installed. Skipping...\n\n"
  else
    # Package not installed
    printf "${action} - Installing $1 ...\n"
    "$aur_helper" -S --noconfirm "$1"
    # Making sure package is installed
    if sudo "$package_manager" -Qs "$1" &>> /dev/null ; then
      printf "${done} - $1 was installed successfully!\n\n"
    else
      # Something is missing, exiting to review log
      printf "${error} - $1 failed to install :( , please check the install.log .Maybe you need to install manually.\n"
    fi
  fi
}