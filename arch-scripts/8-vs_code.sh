#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Js Bro ( https://github.com/me-js-bro ) ####

# exit the script if there is any error
# set -e

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
        --width 40 \
        --margin "1" \
        --padding "1" \
        '
 _   __        _____        __   
| | / /__     / ___/__  ___/ /__ 
| |/ (_-<_   / /__/ _ \/ _  / -_)
|___/___(_)  \___/\___/\_,_/\__/ 
                                 
'
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# log directory
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

log_dir="$parent_dir/Logs"
log="$log_dir/vs_code-$(date +%d-%m-%y).log"

if [[ -f "$log" ]]; then
    source "$log"

    errors=$(grep "ERROR" "$log")
    if [[ -z "$errors" ]]; then
        printf "${note}\n;; No need to run this script again\n"
        sleep 2
        exit 0
    fi

else
    mkdir -p "$log_dir"
    touch "$log"
fi

aur_helper=$(command -v yay || command -v paru) # find the aur helper

vs_code=(
    visual-studio-code-bin
)

# installing vs code
for code in "${vs_code[@]}"; do
    install_from_aur "$code"
    if sudo "$aur_helper" -Qe "$code" &>/dev/null; then
        echo "[ DONE ] - $code was installed successfully!\n" 2>&1 | tee -a "$log" &>/dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $code!\n" 2>&1 | tee -a "$log" &>/dev/null
    fi
done

# updating vs code themes
common_scripts="$parent_dir/common"
"$common_scripts/vs_code_theme.sh"

# clear
