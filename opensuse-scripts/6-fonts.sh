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
        --width 40 \
        --margin "1" \
        --padding "1" \
'
   ____          __    
  / __/__  ___  / /____
 / _// _ \/ _ \/ __(_-<
/_/  \___/_//_/\__/___/
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
log="$log_dir/fonts-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# installable fonts will be here
fonts=(
fira-code-fonts
fontawesome-fonts
google-noto-sans-cjk-fonts
google-noto-coloremoji-fonts
liberation-fonts
noto-sans-mono-fonts
symbols-only-nerd-fonts
xorg-x11-fonts-core
)

# Installation of main components
printf "${action}\n==> Installing necessary fonts"

for font in "${fonts[@]}"; do
  install_package "$font"
    if sudo zypper se -i "$font" &>> /dev/null ; then
        echo "[ DONE ] - $font was installed successfully!" 2>&1 | tee -a "$log" &>> /dev/null
    else
        echo "[ ERROR ] - Could not install $font..." 2>&1 | tee -a "$log" &>> /dev/null
    fi
done

DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
# Maximum number of download attempts
MAX_ATTEMPTS=2
for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
    curl -OL "$DOWNLOAD_URL" && break
    printf "Download attempt $ATTEMPT failed. (╥﹏╥) Retrying in 2 seconds...\n"
    sleep 2
done

# Check if the JetBrainsMono folder exists and delete it if it does
if [ -d ~/.local/share/fonts/JetBrainsMonoNerd ]; then
    rm -rf ~/.local/share/fonts/JetBrainsMonoNerd 2>&1 | tee -a "$log"
fi

mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd
# Extract the new files into the JetBrainsMono folder and log the output
tar -xJkf JetBrainsMono.tar.xz -C ~/.local/share/fonts/JetBrainsMonoNerd 2>&1 | tee -a "$log"

# Update font cache and log the output
printf "${action} - Updating font cache"
fc-cache -v 2>&1 | tee -a "$log" &> /dev/null

# clean up 
if [ -f "JetBrainsMono.tar.xz" ]; then
	rm -r JetBrainsMono.tar.xz
fi

clear
