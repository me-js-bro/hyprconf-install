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

printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"

# log directory
parent_dir="$(dirname "$dir")"
log_dir="$parent_dir/Logs"
log="$log_dir/pywal-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

if command -v pipx &> /dev/null; then
  printf "${attention} - pywal will be installed using ${green}pipx${end}\n" && sleep 1

  pipx install pywal

  if command -v wal &> /dev/null; then
    printf "${done} - pywal was installed successfully!\n" 2>&1 | tee -a "$log"
    sleep 1 && clear
  else
    printf "${error} - Sorry, could not install pywal..\n" 2>&1 | tee -a "$log"
  fi
fi