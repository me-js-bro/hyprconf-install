#!/bin/bash

# I copied this script from JaKooLit. See here https://github.com/JaKooLit

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

display_text() {
    cat << "EOF"
     _   _         _      _  _                  
    | \ | |__   __(_)  __| |(_)  __ _           
    |  \| |\ \ / /| | / _` || | / _` |          
    | |\  | \ V / | || (_| || || (_| |  _  _  _ 
    |_| \_|  \_/  |_| \__,_||_| \__,_| (_)(_)(_)
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global_script.sh"

# log directory
parent_dir="$(dirname "$dir")"
log_dir="$parent_dir/Logs"
log="$log_dir/nvidia-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

nvidia_pkg=(
  dkms
  libvdpau1
  libva-vdpau-driver
  libva-utils
  libglvnd
  libglvnd-devel
  Mesa-libva
  xf86-video-nv
)

nvidia_drivers=(
  nvidia-video-G06
  nvidia-gl-G06
  nvidia-utils-G06
  nvidia-compute-utils-G06
)


# adding NVIDIA repo
sudo zypper -n --quiet ar --refresh -p 90 https://download.nvidia.com/opensuse/tumbleweed NVIDIA 2>&1 | tee -a "$log" || true
sudo zypper --gpg-auto-import-keys refresh 2>&1 | tee -a "$log"


# automatic install of nvidia driver
sudo zypper install-new-recommends --repo NVIDIA 2>&1 | tee -a "$log"

# Install additional Nvidia packages
printf "${action} - Installing Nvidia packages...\n"
 for NVIDIA in "${nvidia_pkg[@]}" "${nvidia_drivers[@]}"; do
   sudo zypper in --auto-agree-with-licenses -y "$NVIDIA"
    if sudo zypper se -i "$NVIDIA" &>> /dev/null ; then
        echo "[ DONE ] - $NVIDIA was installed successfully!" 2>&1 | tee -a "$log" &> /dev/null
    else
        echo "[ ERROR ] - Could not install $NVIDIA..." 2>&1 | tee -a "$log" &> /dev/null
    fi
 done

# adding additional nvidia-stuff
printf "${action} - adding nvidia-stuff to /etc/default/grub..."

# Additional options to add to GRUB_CMDLINE_LINUX
additional_options="rd.driver.blacklist=nouveau modprobe.blacklist=nouveau nvidia-drm.modeset=1"

# Check if additional options are already present in GRUB_CMDLINE_LINUX
if grep -q "GRUB_CMDLINE_LINUX.*$additional_options" /etc/default/grub; then
  echo "GRUB_CMDLINE_LINUX already contains the additional options" 2>&1 | tee -a "$log"
  else
  # Append the additional options to GRUB_CMDLINE_LINUX
  sudo sed -i "s/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"$additional_options /" /etc/default/grub
  echo "Added the additional options to GRUB_CMDLINE_LINUX" 2>&1 | tee -a "$log"
fi

# Update GRUB configuration
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

echo "Nvidia DRM modeset and additional options have been added to /etc/default/grub. Please reboot for changes to take effect." 2>&1 | tee -a "$log"

clear