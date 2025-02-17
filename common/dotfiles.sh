#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Shell Ninja ( https://github.com/shell-ninja ) ####

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"

display_text() {
    gum style \
        --border rounded \
        --align center \
        --width 60 \
        --margin "1" \
        --padding "1" \
'
   ___       __  ____ __      
  / _ \___  / /_/ _(_) /__ ___
 / // / _ \/ __/ _/ / / -_|_-<
/____/\___/\__/_//_/_/\__/___/
                               
'
}

clear && display_text
printf " \n \n"

###------ Startup ------###

dir="$(dirname "$(realpath "$0")")"
parent_dir="$(dirname "$dir")"
source "$parent_dir/interaction_fn.sh"

# log directory
log_dir="$parent_dir/Logs"
log="$log_dir/dotfiles-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

# _______ Testing _______ #

msg act "Clonning the dotfiles repository and setting it to your system..."
# Create the cache directory if it doesn't exist

# Clone the repository and log the output
if [[ ! -d "$parent_dir/.cache/hyprconf" ]]; then
  git clone --depth=1 https://github.com/shell-ninja/hyprconf.git "$parent_dir/.cache/hyprconf" 2>&1 | tee -a "$log" &> /dev/null
fi

sleep 1

# if repo clonned successfully, then setting up the config
if [[ -d "$parent_dir/.cache/hyprconf" ]]; then
  cd "$parent_dir/.cache/hyprconf" || { msg err "Could not changed directory to $parent_dir/.cache/hyprconf" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }

  chmod +x setup.sh
  
  ./setup.sh || { msg err "Could not run the setup script for hyprconf." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log"); exit 1; }
fi

if [[ -f "$HOME/.config/hypr/scripts/startup.sh" ]]; then
  msg dn "Dotfiles setup was successful..." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
else
  msg err "Could not setup dotfiles.." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
  exit 1
fi

sleep 1 && clear

msg att "By default, the keyboard layout will be 'us'"
gum confirm "Is it ok for you?" \
    --prompt.foreground "#ff8700" \
    --affirmative "Yes! Set" \
    --selected.background "#00FFFF" \
    --selected.foreground "#000" \
    --negative "No! Change"

if [ $? -eq 1 ]; then
    layout=$(localectl \
        list-x11-keymap-layouts \
        | gum filter \
        --height 15 \
        --prompt="<> " \
        --cursor-text.foreground "#00FFFF" \
        --indicator.foreground "#00FFFF" \
        --placeholder "Search keyboard layout..."
    )
else
    layout="us"
fi

gum confirm "Would you like to set a keyboard variant?" \
    --prompt.foreground "#ff8700" \
    --affirmative "Sure!" \
    --selected.background "#00FFFF" \
    --selected.foreground "#000" \
    --negative "Skip"

if [ $? -eq 0 ]; then
    variant=$(localectl \
        list-x11-keymap-variants \
        | gum filter \
        --height 15 \
        --prompt="<> " \
        --cursor-text.foreground "#00FFFF" \
        --indicator.foreground "#00FFFF" \
        --placeholder "Find your variant..."
    )
else
    variant=""
fi

msg att "Selected Layout: $layout\n   Selected Variant: ${variant:-None}"

# Apply changes to Hyprland config
config="$HOME/.config/hypr/configs/settings.conf"
sed -i "s/kb_layout = .*/kb_layout = $layout/g" "$config"
sed -i "s/kb_variant = .*/kb_variant = $variant/g" "$config"

echo

msg dn "Setting up the keyboard layout was successful.."

sleep 1 && clear
