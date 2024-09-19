# Arch Linux Desktop Setup

This repository contains automated shell scripts to set up a complete desktop environment on Arch Linux. It simplifies the installation and configuration process by running a series of setup tasks.

## Installation Instructions

### Prerequisites

- **Arch Linux**: These scripts are specifically designed for Arch Linux.
- **Internet Connection**: Required to download necessary packages and repositories.

### Setup Steps

1. **Run Pre-Reboot Script**

   The 'PreReboot.sh' script prepares your system for the desktop environment setup. It installs essential packages and performs initial configuration.

   `curl https://raw.githubusercontent.com/Pand3ru/dotfiles/main/PreReboot.sh | sh`

2. **Reboot Your System**

   After running the 'PreReboot.sh' script, reboot your system to apply the initial changes.

   'sudo reboot'

3. **Run Post-Reboot Script**

   Once your system has rebooted, run the 'PostReboot.sh' script to complete the setup. This script needs to be executed with root privileges.

   `curl https://raw.githubusercontent.com/Pand3ru/dotfiles/main/PostReboot.sh | sudo sh`

## Notes

- **Permissions**: The 'PostReboot.sh' script requires root access to make system-wide changes. Ensure you use 'sudo' when running this script.
- **Customization**: Feel free to modify the scripts according to your specific needs.
- **Post Install**: Find notes about post install struggles [here](https://github.com/Pand3ru/dotfiles/blob/main/notes.md)

## Contact

For any issues or suggestions, please open an issue on the [GitHub repository](https://github.com/Pand3ru/dotfiles).
