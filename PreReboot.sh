#!/bin/bash

function error {
	echo "PRE: $1" >> $HOME/error.log
}

function ask {
	local prompt="$1"
	local def="$2"
	local resp

	read -p "$prompt [y/n] (default: $def) : " resp

	if   [ -z "$resp" ]; then
		resp="$def"
	fi

	resp=$(echo "$resp" | tr '[:upper:]' '[:lower:]')

	case "$resp" in
		[yY]|[yY][eE][sS])
			return 0
			;;
		[nN]|[nN][oO])
			return 1
			;;
		*)
			error "invalid option"
			;;
	esac
}

if [ "$(id -u)" -ne 0 ]; then
	error "This script needs to be ran in root."
fi

echo "Setting up your system"

rm -rf /etc/hostname > /dev/null

# this can stay
echo "Adorsys" > /etc/hostname

echo "Please set your root password"
passwd
wait
# Sleep because of password set message


##########################################

echo "Installing core packages"
pacman -S  --noconfirm efibootmgr gcc vi make grub sudo awk xorg xorg-xinit networkmanager libgnome-keyring libsecret gnome-keyring git docker docker-compose xclip sddm pipewire-alsa pipewire-pulse picom openssh openvpn udiskie flatpak jdk-openjdk maven intellij-idea-community-edition alsa-utils pipewire-jack sof-firmware xf86-input-libinput 
wait
echo "Installing essentials"
pacman -S --noconfirm qt5-quickcontrols2 qt5-graphicaleffects qt5-svg neovim dunst vim seahorse alacritty tmux dolphin firefox gnome-screenshot zathura rofi python-pywal calc feh pavucontrol arandr bluez bluez-utils
wait
echo "Installing fonts"
pacman -S --noconfirm ttf-fira-code ttf-hack ttf-dejavu ttf-inconsolata ttf-jetbrains-mono ttf-ubuntu-font-family ttf-fantasque-sans-mono
wait
# needs user confirmation
pacman -S acpilight
wait


##########################################
echo "Uncomment the following line. This is vi, if you don't know how to use it, ask GPT"
echo "# %wheel ALL=(ALL) ALL"
echo "also add: ALL ALL=NOPASSWD: /bin/lock"
echo "press enter to edit the file"
read
sudo visudo
wait
##########################################


echo "Setting up bootloader"

if [ -d /sys/firmware/efi ]; then
	# UEFI system detected
	if ! mountpoint -q /boot/efi; then
		mkdir -p /boot/efi
		lsblk
		echo "Please enter your EFI partition starting with '/dev/...'"
		read efipart
		wait
		if [ -z "$efipart" ]; then
			echo "Error: Must enter a partition"
			exit 1
		fi
		mount $efipart /boot/efi || { echo "Error mounting $efipart"; exit 1; }
		wait
	fi
	grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub --recheck || { echo "Couldn't install GRUB"; exit 1; }
	wait
	grub-mkconfig -o /boot/grub/grub.cfg || { echo "Failed config generation"; exit 1; }
	wait
else
	# BIOS system detected
	lsblk
	echo "Please enter the device where your system is installed. DO NOT ENTER A SPECIFIC PARTITION"
	read bootpart
	wait
	if [ -z "$bootpart" ]; then
		echo "Error: Must enter a partition"
		exit 1
	fi
	grub-install --target=i386-pc --recheck $bootpart || { echo "Error installing GRUB on $bootpart"; exit 1; }
	wait
	grub-mkconfig -o /boot/grub/grub.cfg || { echo "Failed config generation"; exit 1; }
	wait
fi



##########################################

echo "=== Creating User ==="
echo "Enter prefferred username"
read username
wait
useradd -m -s /bin/bash $username || error "Error creating new user"
echo "Enter the password for $username"
passwd $username
wait
usermod -aG wheel $username

##########################################



if ask "Base setup is finished. Do you want to exit the environment now?" "n"; then
	exit
else
	echo "Exiting installation script"
	exit 0
fi

