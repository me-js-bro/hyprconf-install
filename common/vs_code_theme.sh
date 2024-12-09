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


###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"

# log directory
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

log_dir="$parent_dir/Logs"
log="$log_dir/vs_code_theme-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

vs_code_dir="$HOME/.config/Code"
vs_code_plugins_dir="$HOME/.vscode"

    # backing up vs code directory "Code"
    if [ -d "$vs_code_dir" ]; then
        printf "${action}\n==> Backing up .config/Code directory.\n"
        mv "$vs_code_dir" "$vs_code_dir"-${USER} 2>&1 | tee -a "$log"
    fi

    # backing up vs code directory "Plugins"
    if [ -d "$vs_code_plugins_dir" ]; then
        printf "${action}\n==> Backing up directory.\n"
        mv "$vs_code_plugins_dir" "$vs_code_plugins_dir"-${USER} 2>&1 | tee -a "$log"
    fi
    
# copying vs code themes and plugins dir
printf "${action}\n==> Copying config.\n"
assets_dir="$parent_dir/assets"

cp -r "$assets_dir/Code" "$HOME/.config/" 2>&1 | tee -a "$log"
cp -r "$assets_dir/.vscode" "$HOME/" 2>&1 | tee -a "$log"

sleep 1

fn_done "Vs Code themes and some plugins have been copied"

sleep 1 && clear