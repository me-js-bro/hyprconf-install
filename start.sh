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

# finding the presend directory
present_dir=`pwd`
# creating a cache directory..
cache_dir="$present_dir/.cache"
cache_file="$cache_dir/user-cache"
distro_cache="$cache_dir/distro"

if [[ ! -d "$cache_dir" ]]; then
    mkdir -p "$cache_dir"
fi

# log directory
log_dir="$present_dir/Logs"
log="$log_dir"/1-install.log
mkdir -p "$log_dir"
if [[ ! -f "$log" ]]; then
    touch "$log"
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
                echo "distro=$distro" >> "$distro_cache"
                ;;
            fedora)
                printf "${action} - Starting the script for ${cyan}$ID${end}\n\n"
                distro="fedora"
                echo "distro=$distro" >> "$distro_cache"
                ;;
            opensuse*)
                printf "${action} - Starting the script for ${cyan}$ID${end}\n\n"
                distro="opensuse"
                echo "distro=$distro" >> "$distro_cache"
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



printf "${cyan}Hyprland${end} Installation Script by\n" && sleep 0.5

if [[ "$distro" == "arch" ]]; then
    printf "${orange}          _        ${end}\n"
    printf "${orange}  |  _    |_) __ _  ${end}\n"
    printf "${orange}\_| _)    |_) | (_) ${end}\n"
else
    printf "${orange} ┳   ┳┓     ${end}\n"
    printf "${orange} ┃┏  ┣┫┏┓┏┓ ${end}\n"
    printf "${orange}┗┛┛  ┻┛┛ ┗┛ ${end}\n"
fi



#=========  asking for confirmation  ========= #

printf "Would you like to continue with the script? ${cyan}[ y/n ]${end} \n"
read -r -p "$(echo -e '\e[1;32mSelect: \e[0m')" continue


# =========  startinf if yes, exiting if no  ========= #
case $continue in
    y|Y) printf "Proceeding to the next step...\n"
        clear && sleep 0.5
        ;;
    n|N) printf "Exiting the script here..\n"
        exit 1
        ;;
    *) echo "Please select between [ y/n ]"
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
        printf "${ask} - $question ${cyan}[ y/n ]${end} \n"
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
        printf "${note} - Would you like to run the script again? ${cyan}[ y/n ]${end} \n"
        read -r -p "$(echo -e '\e[1;32mSelect: \e[0m')" run_again

        if [[ "$run_again" =~ ^[Yy]$ ]]; then
            rm -rf "$present_dir/.cache"
            "$present_dir/start.sh"
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
        ask_prompts "Would you like to enable and configure ${green}sddm${end} theme?" "sddm"
        ask_prompts "Would like to install zsh & oh-my-zsh?\nIf no, then we will be customizing your bash with a custom themes created by ${cyan}Js Bro${end}..." "shell"
        ask_prompts "Would you like to install and configure ${cyan}Vs-Code${end}?" "vs_code"
        ask_prompts "Do you have any ${yellow}Nvidia${end} gpu in your system?" "nvidia"
    fi
fi



# =========  script execution  ========= #

scripts_dir="$present_dir/${distro}-scripts"
common_scripts="$present_dir"/common


# =========  run scripts  ========= #

chmod +x "$scripts_dir"/*
chmod +x "$common_scripts"/*

# running scripts
if [[ "$distro" == "arch" ]]; then
    aur=$(command -v yay || command -v paru)
    if [[ -n "$aur" ]]; then
        printf "${done} - Aur helper $aur was located... Moving on\n"
    else
        "$scripts_dir/00-repo.sh"
    fi
elif [[ "$distro" == "fedora" || "$distro" == "opensuse" ]]; then
    "$scripts_dir/00-repo.sh"
fi

# "$scripts_dir"/00-repo.sh
"$scripts_dir/2-hyprland.sh"
"$scripts_dir/3-other_packages.sh"

# nwg-look and pywal installation script only for fedora
if [[ "$distro" == "fedora" ]]; then
    "$scripts_dir/4-nwg_look.sh"
    "$scripts_dir/5-pywal.sh"
fi


"$scripts_dir/6-fonts.sh"

if [[ "$write_bangla" =~ ^[Yy]$ ]]; then
    "$common_scripts/write_bangla.sh"
fi

"$scripts_dir/7-browser.sh"

if [[ "$vs_code" =~ ^[Yy]$ ]]; then
    "$scripts_dir/8-vs_code.sh"
fi

if [[ "$sddm" =~ ^[Yy]$ ]]; then
    "$scripts_dir/9-sddm.sh"
fi

"$scripts_dir/10-xdg_dp.sh"

if [[ "$nvidia" =~ ^[Yy]$ ]]; then
    "$scripts_dir/nvidia.sh"
fi

if [[ "$bluetooth" =~ ^[Yy]$ ]]; then
    "$common_scripts/bluetooth.sh"
fi

if [[ "$shell" =~ ^[Yy]$ ]]; then
    "$common_scripts/zsh.sh"
else 
    "$common_scripts/bash.sh"
fi

"$common_scripts/themes.sh"
"$common_scripts/dotfiles.sh"

clear
sleep 1



# =========  wallpaper section  ========= #

if [[ -d "$HOME/.config/hypr/Wallpaper" ]]; then
  mode_file="$HOME/.mode"
  engine="$HOME/.config/hypr/.cache/.engine"

  touch "$mode_file" &>> /dev/null
  touch "$engine"
  
  echo "dark" >> "$mode_file" &>> /dev/null
  echo "swww" >> "$engine" &>> /dev/null

  wall="$HOME/.config/hypr/Wallpaper/${distro}.png"

      # Transition config
    FPS=60
    TYPE="any"
    DURATION=2
    BEZIER=".43,1.19,1,.4"
    SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

    swww query || swww init
    swww img ${wall} $SWWW_PARAMS &> /dev/null
    "$HOME/.config/hypr/scripts/pywal.sh" &> /dev/null
fi



# =========  set default gtk theme  ========= #

gsettings set org.gnome.desktop.interface gtk-theme "theme"
gsettings set org.gnome.desktop.interface icon-theme "TokyoNight-SE"
gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'



# =========  removing package  ========= #

uninstall_pkg=(
    kitty
    wofi
)

if [[ "$distro" = "arch" ]]; then

    pkg_man=$(command -v pacman || command -v yay || command -v paru)

    for pkg in "${uninstall_pkg[@]}"; do
        if sudo "$pkg_man" -Qs "$pkg" &> /dev/null; then
            printf "${note} - Removing $pkg\n"
            sudo pacman -Rns --noconfirm "$pkg" &> /dev/null
        fi
    done

elif [[ "$distro" = "fedora" ]]; then

    for pkg in "${uninstall_pkg[@]}"; do
        if sudo dnf list installed "$pkg" &> /dev/null; then
            printf "${note} - Removing $pkg\n"
            sudo dnf remove -y "$pkg"  &> /dev/null
        fi
    done

elif [[ "$distro" = "opensuser" ]]; then

    for pkg in "$uninstall_pkg[@]"; do
        if sudo zypper se -i "$pkg" &> /dev/null; then
            printf "${note} - Removing $pkg\n"
            sudo zypper remove -y "$pkg" &> /dev/null
        fi
    done
fi


# =========  system reboot  ========= #

printf "${done} - Congratulations! The script completes here. Now you can enjoy the newly installed Hyprland configuration in your system. The system needs to be rebooted first. would you like to reboot the system? ${cyan}[ y/n ]${end}\n" && sleep 1
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
    printf "${attention} - The system will Reboot in ${cyan}5s ${end}\n" && sleep 1 && clear
    printf "${attention} - The system will Reboot in ${cyan}4s ${end}\n" && sleep 1 && clear
    printf "${attention} - The system will Reboot in ${cyan}3s ${end}\n" && sleep 1 && clear
    printf "${attention} - The system will Reboot in ${cyan}2s ${end}\n" && sleep 1 && clear
    printf "${attention} - The system will Reboot in ${cyan}1s ${end}\n" && sleep 1 && clear

    clear && display_text_reboot && sleep 2

    systemctl reboot --now
else
    printf "${orange}Ok, but it's good to reboot the system. So exiting the script...${end}\n" && sleep 2
    exit 1
fi


# =========______  Script ends here  ______========= #