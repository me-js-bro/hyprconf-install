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

# color defination (hex for gum)
# "#FF0000"       # Bright red
# "#00FF00"     # Bright green
# "#FFFF00"    # Bright yellow
# "#0000FF"      # Bright blue
# "#FF00FF"   # Bright magenta
# "#00FFFF"      # Bright cyan
# "#ff8700"    # Approximation for color code 214 in ANSI (orange)


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
    echo "$1" &> /dev/null
        gum confirm "$2" \
            --affirmative "$3" \
            --selected.background "#00FFFF" \
            --selected.foreground "#000" \
            --negative "$4"
                    
    if [[ $? -eq 0 ]]; then
        sed -i "s/^$1=''/ $1='Y'/" "$cache_file"
    elif [[ $? -eq 1 ]]; then
        sed -i "s/^$1=''/ $1='N'/" "$cache_file"
    fi
}

# choose from options
fn_choose() {
    local choice=$(
        gum choose \
            --no-limit \
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
