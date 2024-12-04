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
log_dir="$dir/Logs"
log="$log_dir"/1-install-$(date +%d-%m-%y).log
mkdir -p "$log_dir"
touch "$log"

# creating a cache directory..
cache_dir="$dir/.cache"
cache_file="$cache_dir/user-cache"
distro_cache="$cache_dir/distro"

# sourcing the interaction prompts
if [[ -f "$dir/interaction_fn.sh" ]]; then
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
                printf "${action}\n:: Starting the script for ${cyan}$ID${end} Linux\n\n"
                distro="arch"
                echo "distro=$distro" >> "$distro_cache" 2>&1 | tee -a "$log"
                ;;
            fedora)
                printf "${action}\n:: Starting the script for ${blue}$ID${end}\n\n"
                distro="fedora"
                echo "distro=$distro" >> "$distro_cache" 2>&1 | tee -a "$log"
                ;;
            opensuse*)
                printf "${action}\n:: Starting the script for ${green}$ID${end}\n\n"
                distro="opensuse"
                echo "distro=$distro" >> "$distro_cache" 2>&1 | tee -a "$log"
                ;;
            *)
                fn_exit "Sorry, the script won't work in your distro for now..."
                ;;
        esac
    else
        printf "${error}\n! Sorry, the script won't work in $ID.\n"
        exit 1
    fi
}

check_distro
clear && fn_welcome && sleep 1

printf "${attention}\n:: Need to install some packages first...\n"
echo

first_packages=(
    git
    gum
)

for pkg in "${first_packages[@]}"; do

    if [[ "$distro" == "arch" ]]; then

        if sudo pacman -Qe "$pkg" &> /dev/null ; then
            fn_done "$pkg was installed already..." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
        else
            printf "${action}\n==>  Installing $pkg"
            if sudo pacman -S --noconfirm "$pkg"; then
                fn_done "$pkg was installed successfully!" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
            fi
        fi

    elif [[ "$distro" == "fedora" ]]; then
        
        if sudo dnf list installed git &> /dev/null ; then
            fn_done "git was installed already..." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
        else
            printf "${action}\n==> Installing git"
            if sudo dnf install -y git; then
                fn_done "git was installed successfully!" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
            fi
        fi

        sleep 1

        printf "${action}\n==> Installing gum"
        chmod +x "$dir/fedora-scripts/gum_install.sh"
        "$dir/fedora-scripts/gum_install.sh"

        if command -v gum &> /dev/null; then
            fn_done "Gum was installed successfully!" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
        fi

    elif [[ "$distro" == "opensuse" ]]; then

        if sudo zypper se -i "$pkg" &> /dev/null; then
            fn_done "$pkg was installed already..." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
        else
            printf "${action}\n==> Installing $pkg"
            if sudo zypper in -y "$pkg"; then
                fn_done "$pkg was installed sucessfully!" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
            fi
        fi

    fi
done

sleep 1 && clear

# starting the main script prompt...
gum spin --spinner line \
         --spinner.foreground "#dddddd" \
         --title "Starting the main script now..." \
         --title.foreground "#dddddd" -- \
         sleep 3
clear


# =========  asking for confirmation  ========= #

fn_ask "Would you like to continue with the script?"
if [[ $? -eq 1 ]]; then
    fn_exit "Exiting the script here..."
fi

clear && display_text && sleep 1
echo

# =========  functions to ask user prompts  ========= #

if [[ -f "$cache_file" ]]; then
    source "$cache_file"

    # Check if Nvidia prompt has no value set
    if [[ -z "$setup_for_Nvidia" ]]; then
        printf "${error} - User prompt was not given properly. Please run the script again...\n" && sleep 0.5

        fn_ask "Would you like to run the script again?"
        if [[ $? -eq 0 ]]; then
            printf "${action}\n==> Starting the script again."
            rm -f "$cache_file"
            "$dir/start.sh"
        else
            fn_exit "Exiting the script here. Goodbye."
        fi
    else
        printf "${attention}\n:: Cache file is there. Skipping prompts...\n\n" && sleep 1
    fi
else
    touch "$cache_file"

    cat > "$cache_file" << EOF
install_Bluetooth_service=''
install_OpenBangla_Keyboard=''
install_brave_or_chromium=''
install_zsh=''
configure_your_default_Bash=''
install_Visual_Studio_Code=''
setup_for_Nvidia=''
EOF

    fn_choose_prompts "install_Bluetooth_service" "install_OpenBangla_Keyboard" "install_brave_or_chromium" "install_zsh" "configure_your_default_Bash" "install_Visual_Studio_Code" "setup_for_Nvidia"

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
        printf "${done} - Aur helper $aur was located... Moving on\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
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

if [[ "$install_OpenBangla_Keyboard" =~ ^[Yy]$ ]]; then
    "$common_scripts/write_bangla.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi


if [[ "$install_brave_or_chromium" =~ ^[Yy]$ ]]; then
    "$scripts_dir/7-browser.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi


if [[ "$install_Visual_Studio_Code" =~ ^[Yy]$ ]]; then
    "$scripts_dir/8-vs_code.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi


"$scripts_dir/9-sddm.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
"$scripts_dir/10-xdg_dp.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")


if [[ "$setup_for_Nvidia" =~ ^[Yy]$ ]]; then
    "$scripts_dir/nvidia.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi


if [[ "$install_Bluetooth_service" =~ ^[Yy]$ ]]; then
    "$common_scripts/bluetooth.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi


if [[ "$install_zsh" =~ ^[Yy]$ ]]; then
    "$common_scripts/zsh.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi


if [[ "$configure_your_default_Bash" =~ ^[Yy]$ ]]; then
    "$common_scripts/bash.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
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
    printf "${attention}\n:: This system is a Desktop. Some configuration will be skipped\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
else
    "$common_scripts/laptop.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

clear
sleep 1


# =========  removing package  ========= #

uninstall_pkg=(
    wofi
)

if [[ "$distro" = "arch" ]]; then

    pkg_man=$(command -v pacman || command -v yay || command -v paru)

    for pkg in "${uninstall_pkg[@]}"; do
        if sudo "$pkg_man" -Qs "$pkg" &> /dev/null; then
            printf "${action}\n==> Removing $pkg"
            sudo pacman -Rns --noconfirm "$pkg" 2>&1 | tee -a "$log" &> /dev/null
        fi
    done

elif [[ "$distro" = "fedora" ]]; then

    for pkg in "${uninstall_pkg[@]}"; do
        if sudo dnf list installed "$pkg" &> /dev/null; then
            printf "${action}\n==> Removing $pkg"
            sudo dnf remove -y "$pkg" 2>&1 | tee -a "$log"  &> /dev/null
        fi
    done

elif [[ "$distro" = "opensuser" ]]; then

    for pkg in "$uninstall_pkg[@]"; do
        if sudo zypper se -i "$pkg" &> /dev/null; then
            printf "${action}\n==> Removing $pkg"
            sudo zypper remove -y "$pkg" 2>&1 | tee -a "$log" &> /dev/null
            sleep 1
            if command -v openbox &> /dev/null; then
                printf "${action}\n==> Removing openbox"
                sudo zypper remove -y openbox 2>&1 | tee -a "$log"
            fi
        fi
    done
fi


# =========  system reboot  ========= #

fn_done "Congratulations! The script completes here." && sleep 2
fn_ask "Need to reboot the syste. Would you like to reboot now?"

# rebooting the system in 5 seconds
if [[ $? -eq 0 ]]; then
    printf "${action}\n==> Rebooting the system in 3s" "3"
    systemctl reboot --now
else
    printf "${orange}[ * ] - Ok, but it's good to reboot the system. Anyway, the script successfully ends here..${end}\n" && sleep 1
    printf "${orange}[ * ] - Enjoy ${cyan}Hyprland. (◠‿◠)${end}\n"
    exit 0
fi


# =========______  Script ends here  ______========= #