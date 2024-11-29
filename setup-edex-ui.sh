#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Update the system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install necessary packages
echo "Installing required packages..."
sudo pacman -S --noconfirm \
    i3 \
    ttf-fira-code \
    alacritty \
    polybar \
    picom \
    rofi \
    yay \
    git

# Install eDEX-UI from AUR
echo "Installing eDEX-UI..."
yay -S --noconfirm edex-ui

# Install a Spacey Wallpaper
echo "Setting space-themed wallpaper..."
mkdir -p $HOME/Pictures
wget -O $HOME/Pictures/space-wallpaper.jpg https://wallpapercave.com/wp/wp6116589.jpg

# Configure i3 as the window manager
echo "Configuring i3..."

# Create a basic i3 config with neon-like colors
cat <<EOF > $HOME/.config/i3/config
# i3 configuration
set \$mod Mod4

# Font settings
font pango:Fira Code 10

# Define colors
set $bg_color #000000
set $fg_color #ffffff
set $urgent_bg #cc0000
set $urgent_fg #ffffff

# Window behavior
new_window 1pixel
new_float 1pixel

# Bar settings (Polybar)
bar {
    status_command i3status
    colors {
        background $bg_color
        statusline $fg_color
        focused_workspace $fg_color $bg_color
        active_workspace $fg_color $bg_color
        inactive_workspace #888888 $bg_color
    }
}
EOF

# Configure Picom for transparency and effects
echo "Configuring Picom..."

mkdir -p $HOME/.config/picom
cat <<EOF > $HOME/.config/picom/picom.conf
# Enable transparency and shadows
fade-in-step = 0.03
fade-out-step = 0.03
shadow = true
shadow-radius = 12
shadow-offset-x = -15
shadow-offset-y = -15
corner-radius = 12
blur-background = true
EOF

# Configure Alacritty with Fira Code font
echo "Configuring Alacritty..."
mkdir -p $HOME/.config/alacritty
cat <<EOF > $HOME/.config/alacritty/alacritty.yml
window:
  opacity: 0.9

font:
  normal:
    family: Fira Code
    style: Regular
  size: 12.0

colors:
  primary:
    background: '#000000'
    foreground: '#ffffff'
  normal:
    black:   '#2e3436'
    red:     '#cc0000'
    green:   '#4e9a06'
    yellow:  '#c4a000'
    blue:    '#3465a4'
    magenta: '#75507b'
    cyan:    '#06989a'
    white:   '#d3d7cf'
  bright:
    black:   '#555753'
    red:     '#ef2929'
    green:   '#8ae234'
    yellow:  '#fce94f'
    blue:    '#729fcf'
    magenta: '#ad7fa8'
    cyan:    '#34e2e2'
    white:   '#eeeeec'
EOF

# Install and configure Polybar for a neon-themed status bar
echo "Configuring Polybar..."

mkdir -p $HOME/.config/polybar
cat <<EOF > $HOME/.config/polybar/config
[colors]
background = #000000
foreground = #ffffff
primary = #00ff00
secondary = #00cc00

[bar/example]
width = 100%
height = 32
background = #000000
foreground = #ffffff
border = 0
modules-left = i3

[module/i3]
type = internal/i3
format = <label>
label-focused = %name%
label-unfocused = %name%
label-urgent = %name%
EOF

# Set wallpaper using feh
echo "Setting wallpaper..."
feh --bg-scale $HOME/Pictures/space-wallpaper.jpg

# Configure Rofi for app launching
echo "Configuring Rofi..."
cat <<EOF > $HOME/.config/rofi/config.rasi
configuration {
    font: "Fira Code 10";
    window {
        width: 50%;
        opacity: 90;
    }
    theme: "space";
}
EOF

# Enable and start services
echo "Enabling and starting Picom, Polybar, and i3..."
systemctl --user enable picom
systemctl --user enable polybar

echo "Setup complete! Please restart your system or log out and log back in to apply changes."

