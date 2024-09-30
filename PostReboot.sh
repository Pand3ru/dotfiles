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
wait

# Clone and set up polybar themes
git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
wait
chmod +x polybar-themes/setup.sh
wait
./polybar-themes/setup.sh || error "Failed to execute setup.sh."
wait

# Clean up old configurations
rm -rf $HOME/.config/polybar || error "Failed to remove old polybar."
rm -rf /etc/xdg/picom.conf || error "Failed to remove old picom.conf."
rm -rf /usr/share/xsessions/ || error "Failed to remove old xsessions."
wait

# Move dotfiles
mv dotfiles/etc/xdg/picom.conf /etc/xdg/picom.conf || error "Failed to move picom.conf."
wait
# Move folders
mv dotfiles/Pictures $HOME || error "Failed to move Pictures."
wait

# Move configuration directories
mv dotfiles/.config/dwm $HOME/.config/ || error "Failed to move dwm configuration."
wait
mv dotfiles/.config/polybar $HOME/.config/ || error "Failed to move polybar configuration."
wait
# Move other files
mv dotfiles/.xinitrc $HOME || error "Failed to move .xinitrc."
wait
chmod +x dotfiles/bin/* || error "Failed to set execute permissions on files in dotfiles/bin/"
wait
mv dotfiles/bin/* /bin || error "Failed to move files to /bin."
wait
mv dotfiles/etc/sddm.conf /etc/ || error "Failed to move sddm.conf."
wait

# Move session files
mv dotfiles/usr/share/xsessions/dwm.desktop /usr/share/xsessions/ || error "Failed to move dwm.desktop."
wait
rm -rf /usr/share/sddm/
wait
# Move sddm themes
mv dotfiles/usr/share/sddm/themes /usr/share/sddm/themes || error "Failed to move sddm themes."
wait

# Install dwm
sudo make -C .config/dwm install || error "Failed to install dwm."
wait

mv dotfiles/.config/gtk-3.0/settings.ini .config/gtk-3.0
wait

# Install yay and other AUR packages
sudo pacman -S --needed git base-devel || error "Failed to install base-devel and git."
wait
git clone https://aur.archlinux.org/yay.git || error "Failed to clone yay repository."
wait
(cd yay && makepkg -si)|| error "Failed to enter yay directory."
wait
yay -S layan-gtk-theme-git networkmanager-dmenu-git polybar-dwm-module i3lockmore-git || error "Failed to install AUR packages."
wait

# Enable necessary system services
modprobe snd_hda_intel
systemctl enable sddm || error "Failed to enable sddm."
wait
sudo systemctl enable --now bluetooth
wait

# Enable necessary user services for PipeWire
systemctl --user enable pipewire || error "Failed to enable user service pipewire."
wait
systemctl --user enable pipewire-pulse || error "Failed to enable user service pipewire-pulse."
wait

# Prompt user for reboot
echo "Setup completed successfully."
echo "Please reboot your system to apply all changes."
