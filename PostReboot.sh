#!/bin/bash

# Function to print error messages and exit
error() {
    echo "POST: $1" >> $HOME/error.log
}

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    error "This script needs to be run as root."
fi

echo "Installing Desktop. This will take a while"

# Clone the dotfiles repository
git clone https://github.com/Pand3ru/dotfiles

# Clone and set up polybar themes
git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
cd polybar-themes || error "Failed to enter polybar-themes directory."
chmod +x setup.sh
./setup.sh || error "Failed to execute setup.sh."
cd ..

# Clean up old configurations
rm -rf $HOME/.config/polybar || error "Failed to remove old polybar."
rm -rf /etc/xdg/picom.conf || error "Failed to remove old picom.conf."
rm -rf /usr/share/xsessions/ || error "Failed to remove old xsessions."

# Move dotfiles
mv dotfiles/etc/xdg/picom.conf /etc/xdg/picom.conf || error "Failed to move picom.conf."

# Move folders
mv dotfiles/Pictures /home/ || error "Failed to move Pictures."

# Move configuration directories
mv dotfiles/.config/dwm /home/.config/ || error "Failed to move dwm configuration."
mv dotfiles/.config/polybar /home/.config/ || error "Failed to move polybar configuration."

# Move other files
mv dotfiles/.xinitrc /home/ || error "Failed to move .xinitrc."
chmod +x dotfiles/bin/* || error "Failed to set execute permissions on files in dotfiles/bin/"
mv dotfiles/bin/* /bin || error "Failed to move files to /bin."

mv dotfiles/etc/sddm.conf /etc/ || error "Failed to move sddm.conf."

# Move session files
mv dotfiles/usr/share/xsessions/dwm.desktop /usr/share/xsessions/ || error "Failed to move dwm.desktop."

# Move sddm themes
mv dotfiles/usr/share/sddm/themes /usr/share/sddm/themes || error "Failed to move sddm themes."

# Install dwm
cd /path/to/dwm/source || error "Failed to enter dwm source directory."
sudo make install || error "Failed to install dwm."

# Install yay and other AUR packages
sudo pacman -S --needed git base-devel || error "Failed to install base-devel and git."
git clone https://aur.archlinux.org/yay.git || error "Failed to clone yay repository."
cd yay || error "Failed to enter yay directory."
makepkg -si || error "Failed to build and install yay."
cd ..
yay -S networkmanager-dmenu-git polybar-dwm-module i3lock-color || error "Failed to install AUR packages."

# Enable necessary system services
systemctl enable sddm || error "Failed to enable sddm."

# Enable necessary user services for PipeWire
systemctl --user enable pipewire || error "Failed to enable user service pipewire."
systemctl --user enable pipewire-pulse || error "Failed to enable user service pipewire-pulse."

# Prompt user for reboot
echo "Setup completed successfully."
echo "Please reboot your system to apply all changes."
