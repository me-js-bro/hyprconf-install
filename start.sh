#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Js Bro ( https://github.com/me-js-bro ) ####

# exit the script if there's any error
#set -e

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"

# color defination (hex for gum)
red_hex="#FF0000"       # Bright red
green_hex="#00FF00"     # Bright green
yellow_hex="#FFFF00"    # Bright yellow
blue_hex="#0000FF"      # Bright blue
magenta_hex="#FF00FF"   # Bright magenta (corrected spelling)
cyan_hex="#00FFFF"      # Bright cyan
orange_hex="#FFAF00"    # Approximation for color code 214 in ANSI (orange)

# log directory
dir="$(dirname "$(realpath "$0")")"
source "$dir/interaction_fn.sh"
log_dir="$dir/Logs"
log="$log_dir"/1-install-$(date +%d-%m-%y).log
mkdir -p "$log_dir"
touch "$log"

# creating a cache directory..
cache_dir="$dir/.cache"
cache_file="$cache_dir/user-cache"
distro_cache="$cache_dir/distro"

# sourcing the interaction prompts
if [[  "$dir/interaction_fn.sh" ]]; then
    source "$dir/interaction_fn.sh"
fi

if [[ ! -d "$cache_dir" ]]; then
    mkdir -p "$cache_dir"
fi

display_text() {
    cat << "EOF"     
   __  ___     _        ____        _      __ 
  /  |/  /__ _(_)__    / __/_______(_)__  / /_
 / /|_/ / _ `/ / _ \  _\ \/ __/ __/ / _ \/ __/
/_/  /_/\_,_/_/_//_/ /___/\__/_/ /_/ .__/\__/ 
                                  /_/                            
EOF
}


# =========  checking the distro  ========= #

check_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            arch)
                msg act "Starting the script for ${cyan}$ID${end} Linux\n\n"
                distro="arch"
                echo "distro=$distro" >> "$distro_cache" 2>&1 | tee -a "$log"
                ;;
            fedora)
                msg act "Starting the script for ${blue}$ID${end}\n\n"
                distro="fedora"
                echo "distro=$distro" >> "$distro_cache" 2>&1 | tee -a "$log"
                ;;
            opensuse*)
                msg act "Starting the script for ${green}$ID${end}\n\n"
                distro="opensuse"
                echo "distro=$distro" >> "$distro_cache" 2>&1 | tee -a "$log"
                ;;
            *)
                fn_exit "Sorry, the script won't work in your distro for now..."
                ;;
        esac
    else
        msg err "Sorry, the script won't work in $ID."
        exit 1
    fi
}

check_distro
clear && fn_welcome && sleep 1

# starting the main script prompt...
gum spin --spinner line \
         --spinner.foreground "#dddddd" \
         --title "Starting the main script for ${distro} linux..." \
         --title.foreground "#dddddd" -- \
         sleep 3
clear

# =========  functions to ask user prompts  ========= #

if [[ -f "$cache_file" ]]; then
    source "$cache_file"

    # Check if Nvidia prompt has no value set
    if [[ -z "$Nvidia" ]]; then
        msg err "User prompt was not given properly. Please run the script again..."

        fn_ask "Would you like to run the script agaain?" "Yes, sure." "No, close it."

        if [[ $? -eq 0 ]]; then
            gum spin --spinner dot --title "Starting the script again.." -- sleep 3
            rm -f "$cache_file"
            "$dir/start.sh"
        else
            fn_exit "Exiting the script here. Goodbye."
        fi
    else
        msg att "Cache file is there. Skipping prompts..."
    fi
else
    touch "$cache_file"
    cat > "$cache_file" << EOF
Bluetooth=''
Shell=''
Keyb=''
VS_code=''
Nvidia=''
EOF

    # asking prompts
    fn_ask_prompts "Bluetooth" "Would you like to enable Bluetooth service?" "Yes!" "No!"
    fn_ask_prompts "Shell" "Would you like to..." "Configure zsh" "Configure Bash"
    fn_ask_prompts "Keyb" "Would you like to install Openbangla Keyboard?" "Yes!" "No!"
    fn_ask_prompts "VS_code" "Would you like to install VS Code?" "Yes!" "No!"
    fn_ask_prompts "Nvidia" "Do you have Nvidia GPU?" "Yes!" "No!"

    source "$cache_file"
fi


# =========  script execution  ========= #

scripts_dir="$dir/${distro}-scripts"
common_scripts="$dir"/common

# =========  run scripts  ========= #

chmod +x "$scripts_dir"/* 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
chmod +x "$common_scripts"/* 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")

clear
# running scripts
if [[ "$distro" == "arch" ]]; then
    aur=$(command -v yay || command -v paru)
    if [[ -n "$aur" ]]; then
        msg dn "Aur helper $aur was located... Moving on" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
        sleep 1
    else
        "$scripts_dir/00-repo.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    fi
elif [[ "$distro" == "fedora" || "$distro" == "opensuse" ]]; then
    "$scripts_dir/00-repo.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

# "$scripts_dir"/00-repo.sh
"$scripts_dir/2-hyprland.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
"$scripts_dir/3-other_packages.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")

"$scripts_dir/6-fonts.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")

if [[ "$Keyb" =~ ^[Yy]$ ]]; then
    "$common_scripts/write_bangla.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

"$scripts_dir/7-browser.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")

if [[ "$VS_code" =~ ^[Yy]$ ]]; then
    "$scripts_dir/8-vs_code.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

"$scripts_dir/9-sddm.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
"$scripts_dir/10-xdg_dp.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
"$scripts_dir/11-uninstall.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")

if [[ "$Nvidia" =~ ^[Yy]$ ]]; then
    "$scripts_dir/nvidia.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

if [[ "$Bluetooth" =~ ^[Yy]$ ]]; then
    "$common_scripts/bluetooth.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

if [[ "$Shell" =~ ^[Yy]$ ]]; then
    "$common_scripts/zsh.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
elif [[ "$Shell" =~ ^[Nn]$ ]]; then
    "$common_scripts/bash.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

# only for opensuse ( hyprsunset )
if [[ "$distro" == "opensuse" ]]; then
    "$scripts_dir/2.1-hyprsunset.sh"
fi


"$common_scripts/themes.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
"$common_scripts/dotfiles.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")

# Function to check for the presence of a battery
is_laptop() {
    if [[ -d "/sys/class/power_supply/BAT0" ]]; then
        echo "Laptop" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    else
        echo "Desktop" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    fi
}

# Determine if the system is a laptop or desktop
system_type=$(is_laptop)
if [ "$system_type" = "Desktop" ]; then
    msg nt "This system is a Desktop. Some configuration will be skipped.." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log") && sleep 2
else
    "$common_scripts/laptop.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

sleep 1 && clear


# =========  system reboot  ========= #

msg dn "Congratulations! The script completes here." && sleep 2
msg att "Need to reboot the system."

fn_ask "Would you like to reboot now?" "Reboot" "No, skip"
if [[ $? -eq 0 ]]; then
    clear
    # rebooting the system in 3 seconds
    for second in 3 2 1; do
        printf ":: Rebooting the system in ${second}s\n" && sleep 1 && clear
    done
        systemctl reboot --now
else
    msg nt "Ok, but make sure to reboot the system...\n   See you later.(◠‿◠)" && sleep 1
    exit 0
fi

# =========______  Script ends here  ______========= #
