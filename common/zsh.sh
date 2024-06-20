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

display_text() {
    cat << "EOF"
   _____      _               
  |__  / ___ | |__            
    / / / __|| '_ \           
   / /_ \__ \| | | |  _  _  _ 
  /____||___/|_| |_| (_)(_)(_)
   
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# finding the presend directory and log file
present_dir=`pwd`
cache_dir="$present_dir/.cache"
distro_cache="$cache_dir/distro"
if [[ -f "$distro_cache" ]]; then
    source "$distro_cache"
fi

# log directory
log_dir="$present_dir/Logs"
log="$log_dir"/zsh.log
mkdir -p "$log_dir"
if [[ ! -f "$log" ]]; then
    touch "$log"
fi

# install script dir
scripts_dir="$present_dir/${distro}-scripts"
source $scripts_dir/1-global_script.sh

zsh=(
  bat
  lsd
  util-linux
  zsh 
)


# Installing zsh packages
printf "${action} - Installing core zsh packages\n"
for zsh_pkg in "${zsh[@]}"; do
  install_package "$zsh_pkg"
done

printf "\n"

# ---- oh-my-zsh installation ---- #
printf "${action} - Now installing ${orange}' oh-my-zsh, zsh-autosuggestions, zsh-syntax-highlighting '${end}...\n"
sleep 2

oh_my_zsh_dir="$HOME/.oh-my-zsh"

if [ -d "$oh_my_zsh_dir" ]; then
    printf "${attention} - $oh_my_zsh_dir located, it is necessary to remove or rename it for the installation process. So backing it up...\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")
    mv $oh_my_zsh_dir "$oh_my_zsh_dir"-${USER}
fi

 	  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \

printf "${done} - Installation completed...\n"

# changing shell
  user_shell=$(echo $SHELL)
  if [[ $user_shell == "/usr/bin/zsh" ]]; then
    printf "${note} - Your shell is already zsh. No need to change it.\n"
  else
    printf "${action} - Changing shell to ${cyan}zsh ${end}\n"
    chsh -s $(which zsh) 2>&1 | tee -a "$log"
  fi
sleep 1

printf "${action} - Now proceeding to the next step, Configuring $HOME/.zshrc file\n"

sleep 1

zshrc="$HOME/.zshrc"

if [[ -f "$zshrc" ]]; then
    mv "$zshrc" "$zshrc"-${USER}
fi

cp -r "$present_dir/assets/.zsh" ~/

if [[ -d "$HOME/.zsh" ]]; then
    ln -sf "$HOME/.zsh/.zshrc" ~/.zshrc
fi

cp -r "$present_dir/assets/lsd" "$HOME/.config/"

printf "${done} - Installation and configuration of ${cyan}zsh and oh-my-zsh ${end}finished!\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")

printf "${done} - You can change your ${orange}oh-my-zsh${end} theme using a keyboard shortcut, ${green}'Mod + Alt + B'${end}\n" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log")

sleep 2
clear