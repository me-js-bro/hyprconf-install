#!/bin/bash

#### Advanced Hyprland Installation Script by ####
#### Js Bro ( https://github.com/me-js-bro ) ####

# I copied this script from JaKooLit. See here https://github.com/JaKooLit

# exit the script if there is any error
set -e

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
   _  __     _    ___     
  / |/ /_ __(_)__/ (_)__ _
 /    / |/ / / _  / / _ `/
/_/|_/|___/_/\_,_/_/\_,_/ 
                          
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
log="$log_dir/nvdia-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

nvidia_pkg=(
  nvidia-dkms
  nvidia-settings
  nvidia-utils
  libva
  libva-nvidia-driver-git
)

# nvidia stuff
printf "${action}\n==> Checking for other hyprland packages and remove if any.\n"
if pacman -Qs hyprland &> /dev/null; then
    printf "${action}\n==> Hyprland detected. uninstalling to install Hyprland from official repo.\n"

    for hyprnvi in hyprland-git hyprland-nvidia hyprland-nvidia-git hyprland-nvidia-hidpi-git; do
    sudo pacman -Rns --noconfirm "$hyprnvi" 2>&1 | tee -a "$log" &> /dev/null
    done
fi

# Install additional Nvidia packages
printf "${action}\n==> Installing addition Nvidia packages.\n"
for krnl in $(cat /usr/lib/modules/*/pkgbase); do
  for NVIDIA in "${krnl}-headers" "${nvidia_pkg[@]}"; do
    install_package "$NVIDIA" 2>&1 | tee -a "$log"
  done
done

# Check if the Nvidia modules are already added in mkinitcpio.conf and add if not
if grep -qE '^MODULES=.*nvidia. *nvidia_modeset.*nvidia_uvm.*nvidia_drm' /etc/mkinitcpio.conf; then
  echo ":: Nvidia modules already included in /etc/mkinitcpio.conf" 2>&1 | tee -a "$log"
else
  sudo sed -Ei 's/^(MODULES=\([^\)]*)\)/\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf 2>&1 | tee -a "$log"
  echo ":: Nvidia modules added in /etc/mkinitcpio.conf"
fi

sudo mkinitcpio -P 2>&1 | tee -a "$log"
printf "\n\n\n"

# Additional Nvidia steps
NVEA="/etc/modprobe.d/nvidia.conf"
if [ -f "$NVEA" ]; then
  fn_done "Seems like nvidia-drm modeset=1 is already added in your system..moving on."
else
  printf "${action}\n==> Adding options to $NVEA.\n"
  sudo echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf 2>&1 | tee -a "$log"
  echo
fi

# additional for GRUB users
# Check if /etc/default/grub exists
if [ -f /etc/default/grub ]; then
    # Check if nvidia_drm.modeset=1 is already present
    if ! sudo grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
        # Add nvidia_drm.modeset=1 to GRUB_CMDLINE_LINUX_DEFAULT
        sudo sed -i 's/\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 nvidia-drm.modeset=1"/' /etc/default/grub
        # Regenerate GRUB configuration
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        echo ":: nvidia-drm.modeset=1 added to /etc/default/grub" 2>&1 | tee -a "$log"
    else
        echo ":: nvidia-drm.modeset=1 is already present in /etc/default/grub" 2>&1 | tee -a "$log"
    fi
else
    echo "/etc/default/grub does not exist"
fi

# Blacklist nouveau
fn_ask "Would you like to blacklist nouveau?" 
if [[ $? -eq 0 ]]; then
  NOUVEAU="/etc/modprobe.d/nouveau.conf"
  if [ -f "$NOUVEAU" ]; then
    fn_done "Seems like nouveau is already blacklisted..moving on"
  else
    printf "\n"
    echo "blacklist nouveau" | sudo tee -a "$NOUVEAU" 2>&1 | tee -a "$log"
    fn_done "Has been added to $NOUVEAU"

    # To completely blacklist nouveau (See wiki.archlinux.org/title/Kernel_module#Blacklisting 6.1)
    if [ -f "/etc/modprobe.d/blacklist.conf" ]; then
      echo "install nouveau /bin/true" | sudo tee -a "/etc/modprobe.d/blacklist.conf" 2>&1 | tee -a "$log"
    else
      echo "install nouveau /bin/true" | sudo tee "/etc/modprobe.d/blacklist.conf" 2>&1 | tee -a "$log"
    fi
  fi
else
  fn_error "Skipping nouveau blacklisting." 2>&1 | tee -a "$log"
fi

clear