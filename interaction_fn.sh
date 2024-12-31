#!/bin/bash
# initial user interection functions...

# color defination (ascii)
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
megenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\x1b[38;5;214m"
end="\e[1;0m"

# initial texts
attention="[${orange} ATTENTION ${end}]"
action="[${green} ACTION ${end}]"
note="[${megenta} NOTE ${end}]"
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
orange_hex="#ff8700"    # Approximation for color code 214 in ANSI (orange)


# cache dir
dir="$(dirname "$(realpath "$0")")"

# creating a cache directory..
cache_dir="$dir/.cache"
cache_file="$cache_dir/user-cache"

if [[ ! -d "$cache_dir" ]]; then
    mkdir -p "$cache_dir"
fi


#______( starts functions here )______#

fn_welcome() {
    gum style \
        --foreground "$cyan_hex" \
        --border-foreground "$cyan_hex" \
        --border rounded \
        --align center \
        --width 60 \
        --margin "1 2" \
        --padding "1 2" \
    'Welcome to the' 'Hyprland installation script by,' '
     __      ___         
 __ / /__   / _ )_______ 
/ // (_-<  / _  / __/ _ \
\___/___/ /____/_/  \___/
'
}

fn_ask() {
    gum confirm "$1" \
        --affirmative "$2" \
        --selected.background "$cyan_hex" \
        --selected.foreground "#000" \
        --negative "$3"
}

fn_exit() {
    gum spin --spinner line \
    --spinner.foreground "$red_hex" \
    --title "$1" \
    --title.foreground "$red_hex" -- \
    sleep 1

    exit 1
}

# only for asking the prompts...
fn_choose_prompts() {
    printf "${attention}\n:: You can choose multiple options. Just press 'Space' and the option will be chosen.\n"

    # Show options with gum and capture multiple selections
    local choice=$(gum choose --no-limit "$@")
    for option in "$@"; do
        if echo "$choice" | grep -q "$option"; then
            sed -i "s/^$option=''/ $option='Y'/" "$cache_file"
        else
            sed -i "s/^$option=''/ $option='N'/" "$cache_file"
        fi
    done
}

msg() {
    local actn="$1"
    local msg="$2"

    case $actn in
        act)
            printf "${green}=>${end} $msg\n"
            ;;
        ask)
            printf "${orange}??${end} $msg\n"
            ;;
        dn)
            printf "${cyan}::${end} $msg\n"
            ;;
        att)
            printf "${yellow}!!${end} $msg\n"
            ;;
        nt)
            printf "${blue}\$\$${end} $msg\n"
            ;;
        err)
            printf "${red}>< Ohh sheet! an error..${end}\n   $msg\n"
            sleep 1
            ;;
        *)
            printf "$msg\n"
            ;;
    esac
}
