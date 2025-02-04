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

# cache dir
dir="$(dirname "$(realpath "$0")")"

# creating a cache directory..
cache_dir="$dir/.cache"
cache_file="$cache_dir/user-cache"

[[ ! -d "$cache_dir" ]] && mkdir -p "$cache_dir"

#______( starts functions here )______#

fn_welcome() {
    gum style \
        --foreground "#00FFFF" \
        --border-foreground "#00FFFF" \
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
        --prompt.foreground "#ff8700" \
        --affirmative "$2" \
        --selected.background "#00FFFF" \
        --selected.foreground "#000" \
        --negative "$3"
}

fn_exit() {
    gum spin --spinner line \
    --spinner.foreground "#FF0000" \
    --title "$1" \
    --title.foreground "#FF0000" -- \
    sleep 1

    exit 1
}


# only for asking the prompts...
fn_ask_prompts() {
    echo "Choose features you want to use."

    # Use gum to capture selected options
    local selected
    selected=$(gum choose --header "Select using the 'space' button:" --no-limit "${!options[@]}")
    
    # Reset all options to 'N' by default
    for key in "${!options[@]}"; do
        options[$key]="N"
    done

    # Set the selected options to 'Y'
    for key in $selected; do
        options[$key]="Y"
    done

    # Update the cache file with the new values
    > "$cache_file"
    for key in "${!options[@]}"; do
        echo "$key='${options[$key]}'" >> "$cache_file"
    done

    cat "$cache_file"
}

# choose from options
fn_choose() {
    local choice=$(
        gum choose \
            --cursor.foreground "#00FFFF" \
            --item.foreground "#fff" \
            --selected.foreground "#00FF00" \
            "$@"
    )
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
        skp)
            printf "${magenta}[ SKIP ]${end} $msg\n"
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
