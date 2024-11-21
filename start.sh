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

if [[ ! -d "$cache_dir" ]]; then
    mkdir -p "$cache_dir"
fi

display_text() {
    cat << "EOF"
    _______ __   __      __   _ _______ _______ _______      _____ _______
    |  |  |   \_/        | \  | |_____| |  |  | |______        |   |______
    |  |  |    |         |  \_| |     | |  |  | |______      __|__ ______|  

            .___  ___.      ___       __    __   __  .__   __.
            |   \/   |     /   \     |  |  |  | |  | |  \ |  |
            |  \  /  |    /  ^  \    |  |__|  | |  | |   \|  |
            |  |\/|  |   /  /_\  \   |   __   | |  | |  . `  |
            |  |  |  |  /  _____  \  |  |  |  | |  | |  |\   |
            |__|  |__| /__/     \__\ |__|  |__| |__| |__| \__|

                        ______  _______ _  _  _
                        |_____]    |    |  |  |
                        |_____]    |    |__|__|    
EOF
}


###------ Startup ------###


# =========  checking the distro  ========= #

check_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            arch)
                printf "${action} - Starting the script for ${cyan}$ID${end} Linux\n\n"
                distro="arch"
                echo "distro=$distro" >> "$distro_cache" 2>&1 | tee -a "$log"
                ;;
            fedora)
                printf "${action} - Starting the script for ${blue}$ID${end}\n\n"
                distro="fedora"
                echo "distro=$distro" >> "$distro_cache" 2>&1 | tee -a "$log"
                ;;
            opensuse*)
                printf "${action} - Starting the script for ${green}$ID${end}\n\n"
                distro="opensuse"
                echo "distro=$distro" >> "$distro_cache" 2>&1 | tee -a "$log"
                ;;
            *)
                printf "${error} - Sorry, the script won't work in your distro...\n"
                exit 1
                ;;
        esac
    else
        printf "${error} - Sorry, the script won't work in $ID...\n"
        exit 1
    fi
}

clear && sleep 1

printf "${cyan}Starting the Installation Script${end}.\n" && sleep 1 && clear
printf "${cyan}Starting the Installation Script${end}..\n" && sleep 1 && clear
printf "${cyan}Starting the Installation Script${end}...\n" && sleep 1

check_distro && sleep 1 && clear


printf "${cyan}Hyprland${end} Installation Script by,\n" && sleep 0.5

if [[ "$distro" == "arch" && "$distro" == "opensuse" ]]; then
    printf "${orange}          _        ${end}\n"
    printf "${orange}  |  _    |_) __ _  ${end}\n"
    printf "${orange}\_| _)    |_) | (_) ${end}\n"
elif [[ "$distro" == "fedora" ]]; then
    printf "${orange} ┳   ┳┓     ${end}\n"
    printf "${orange} ┃┏  ┣┫┏┓┏┓ ${end}\n"
    printf "${orange}┗┛┛  ┻┛┛ ┗┛ ${end}\n"
fi



# =========  asking for confirmation  ========= #

printf "Would you like to continue with the script? ${cyan}[ ${green}y${end}/${red}n ${cyan}]${end} \n"
read -r -p "$(echo -e '\e[1;32mSelect: \e[0m')" continue


# =========  startinf if yes, exiting if no  ========= #
case $continue in
    y|Y) printf "Proceeding to the next step...\n"
        clear && sleep 0.5
        ;;
    n|N) printf "Exiting the script here..\n"
        exit 1
        ;;
    *) echo "Please select between ${cyan}[ ${green}y${end}/${red}n ${cyan}]${end}"
        exit 1
        ;;
esac

display_text && sleep 1
printf " \n"



# =========  functions to ask user prompts  ========= #

ask_prompts() {
    local question="$1"
    local var_name="$2"

    # Check if the variable referenced by var_name is not empty
    if [[ -n "${!var_name}" ]]; then
        if [[ "${!var_name}" =~ ^[Yy]$ ]]; then
            return 0
        else
            return 1
        fi
    fi

    while true; do
        printf "${ask} - $question ${cyan}[ ${green}y${end}/${red}n ${cyan}]${end} \n"
        read -r -p "$(echo -e '\e[1;32mSelect: \e[0m')" choice
        printf " \n"
        case "$choice" in
            [Yy]* )
                eval "$var_name='Y'"
                echo "$var_name='Y'" >> "$cache_file"
                return 0
                ;;
            [Nn]* )
                eval "$var_name='N'"
                echo "$var_name='N'" >> "$cache_file"
                return 1
                ;;
            * )
                echo "Please answer with y or n."
                ;;
        esac
    done
}



# =========  caching  ========= #

if [[ -f "$cache_file" ]]; then
    source "$cache_file"

    # exit if there is no coices
    if [[ "$nvidia" == "" ]]; then
        printf "${error} - User prompt was not given properly. Please run the script again...\n" && sleep 0.5
        printf "${note} - Would you like to run the script again? ${cyan}[ ${green}y${end}/${red}n ${cyan}]${end} \n"
        read -r -p "$(echo -e '\e[1;32mSelect: \e[0m')" run_again

        if [[ "$run_again" =~ ^[Yy]$ ]]; then
            rm -rf "$dir/.cache" 2>&1 | tee -a "$log"
            "$dir/start.sh" 2>&1 | tee -a "$log"
        else
            exit 1
        fi
    else
        printf "${attention} - Cache file is there. No need to answer the questions again.\n\n" && sleep 1
    fi
else
    if [[ ! -f "$cache_file" ]]; then
        touch "$cache_file"

        bluetooth=""
        write_bangla=""
        sddm=""
        shell=""
        vs_code=""
        nvidia=""
        
        # Ask user prompts if cache file doesn't contain variables
        ask_prompts "Would you like to install and enable ${blue}Bluetooth${end} service?" "bluetooth"
        ask_prompts "Would like to install ${yellow}Openbangla keyboard${end} and ${yellow}fcitx${end} to write in Bangla?" "write_bangla"
        ask_prompts "Would you like to install ${orange}Brave Browser${end} or ${cyan}Chromium${end}?" "browsr"
        ask_prompts "Would you like to enable and configure ${green}sddm${end} theme?" "sddm"
        ask_prompts "Would like to install zsh & oh-my-zsh?\nIf no, then we will be customizing your bash with a custom themes created by ${cyan}Js Bro${end}..." "shell"
        ask_prompts "Would you like to install and configure ${cyan}Vs-Code${end}?" "vs_code"
        ask_prompts "Do you have any ${yellow}Nvidia${end} gpu in your system?" "nvidia"
    fi
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

# pywal installation script only for fedora
if [[ "$distro" == "fedora" ]]; then
    "$scripts_dir/5-pywal.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi


"$scripts_dir/6-fonts.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")

if [[ "$write_bangla" =~ ^[Yy]$ ]]; then
    "$common_scripts/write_bangla.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

if [[ "$browsr" =~ ^[Yy]$ ]]; then
    "$scripts_dir/7-browser.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

if [[ "$vs_code" =~ ^[Yy]$ ]]; then
    "$scripts_dir/8-vs_code.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

if [[ "$sddm" =~ ^[Yy]$ ]]; then
    "$scripts_dir/9-sddm.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

"$scripts_dir/10-xdg_dp.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")

if [[ "$nvidia" =~ ^[Yy]$ ]]; then
    "$scripts_dir/nvidia.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

if [[ "$bluetooth" =~ ^[Yy]$ ]]; then
    "$common_scripts/bluetooth.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
fi

if [[ "$shell" =~ ^[Yy]$ ]]; then
    "$common_scripts/zsh.sh" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
else 
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
    printf "${attention} - This system is a Desktop. Some configuration will be skipped\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
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
            printf "${attention} - Removing $pkg\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
            sudo pacman -Rns --noconfirm "$pkg" 2>&1 | tee -a "$log" &> /dev/null
        fi
    done

elif [[ "$distro" = "fedora" ]]; then

    for pkg in "${uninstall_pkg[@]}"; do
        if sudo dnf list installed "$pkg" &> /dev/null; then
            printf "${attention} - Removing $pkg\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
            sudo dnf remove -y "$pkg" 2>&1 | tee -a "$log"  &> /dev/null
        fi
    done

elif [[ "$distro" = "opensuser" ]]; then

    for pkg in "$uninstall_pkg[@]"; do
        if sudo zypper se -i "$pkg" &> /dev/null; then
            printf "${attention} - Removing $pkg\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
            sudo zypper remove -y "$pkg" 2>&1 | tee -a "$log" &> /dev/null
            sleep 1
            if command -v openbox &> /dev/null; then
                printf "${attention} - Removing openbox.\n"
                sudo zypper remove -y openbox 2>&1 | tee -a "$log"
            fi
        fi
    done
fi


# =========  system reboot  ========= #

printf "${done} - Congratulations! The script completes here. Now you can enjoy the newly installed Hyprland configuration in your system. The system needs to be rebooted first. would you like to reboot the system? ${cyan}[ ${green}y${end}/${red}n ${cyan}]${end}\n" && sleep 1
read -r -p "$(echo -e '\e[1;32mSelect: \e[0m')" reboot


display_text_reboot() {
    cat << "EOF"
  ____        _                    _    _                                                              _                            
 |  _ \  ___ | |__    ___    ___  | |_ (_) _ __    __ _   _   _   ___   _   _  _ __   ___  _   _  ___ | |_  ___  _ __ ___           
 | |_) |/ _ \| '_ \  / _ \  / _ \ | __|| || '_ \  / _` | | | | | / _ \ | | | || '__| / __|| | | |/ __|| __|/ _ \| '_ ` _ \          
 |  _ <|  __/| |_) || (_) || (_) || |_ | || | | || (_| | | |_| || (_) || |_| || |    \__ \| |_| |\__ \| |_|  __/| | | | | | _  _  _ 
 |_| \_\\___||_.__/  \___/  \___/  \__||_||_| |_| \__, |  \__, | \___/  \__,_||_|    |___/ \__, ||___/ \__|\___||_| |_| |_|(_)(_)(_)
                                                  |___/   |___/                            |___/                                      
EOF
}


# rebooting the system in 5 seconds
if [[ "$reboot" =~ ^[Yy]$ ]]; then
    sleep 0.5 && clear
    for time in 5 4 3 2 1; do
        printf "${attention} - The system will Reboot in ${cyan}${time}s ${end}\n"
        sleep 1 && clear
    done

    clear && display_text_reboot && sleep 2

    systemctl reboot --now
else
    printf "${orange}[ * ] - Ok, but it's good to reboot the system. Anyway, the script successfully ends here..${end}\n" && sleep 1
    printf "${orange}[ * ] - Enjoy ${cyan}Hyprland. (◠‿◠)${end}\n"
    exit 0
fi


# =========______  Script ends here  ______========= #