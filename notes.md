# Notes for Post Installation
Due to the nature of arch and now having a complete Desktop Environment, some features will only work to some extend or might not work at all.

Here is a list of things that I have encountered that might solve some issues

# No sound
If you happen to have no sound on your system, start amixer and go through your soundcard settings. `MM` has not worked for me so get rid of these values

# No Touchpad tapping
Create a file `/etc/X11/xorg.conf.d/99-synaptics-overrides.conf`
and add following content
```
Section "InputClass"
    Identifier "touchpad overrides"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "TappingButtonMap" "lmr"
EndSection
```

# Topbar doesn't show wifi connection
1. Look for the name of your wifi interface via `ip a`
2. Edit `.config/polybar/forest/modules.ini`
3. Look for the Network section and change the interface name

# Adding Wallpapers
Adding Wallpapers is as simple as moving the new wallpaper into `Pictures/Wallpapers`

# Display Brightness
I could not bring xbacklight to work so I installed acpilight instead.
In order for it to work via a keybing I added following line to visudo:
`ALL ALL=NOPASSWD: /bin/xbacklight`

# Getting XF86 keys to work under DWM
On the top of your `config.h` file add: 
```C
#include <X11/XF86keysym.h>
```
