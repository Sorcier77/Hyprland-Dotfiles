#!/usr/bin/bash

# File to store the state
state_file=/tmp/low_power_mode
css_file=~/.config/waybar/style.css
wallpaper=~/.config/wallpaper
low_power_wallpaper=~/.config/low_power_wallpaper

# Function to check if the file is a GIF
is_gif() {
    file "$1" | grep -qE 'GIF image'
}

# Function to enable low power mode
enable_low_power_mode() {
    sed -i 's/background-color: @frost_light;/background-color: @aurora_yellow;/g' "$css_file"
    touch "$state_file"
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword decoration:drop_shadow false
    hyprctl keyword animations:enabled false
    hyprctl keyword decoration:active_opacity 2
    hyprctl keyword decoration:inactive_opacity 2
    if is_gif "$wallpaper"; then
        convert "$wallpaper"[0] "$low_power_wallpaper"
        swww img "$low_power_wallpaper"
    fi
    notify-send "Low Power Mode Enabled"
    killall waybar && waybar
}

# Function to disable low power mode
disable_low_power_mode() {
    sed -i 's/background-color: @aurora_yellow;/background-color: @frost_light;/g' "$css_file"
    rm "$state_file"
    hyprctl reload
    swww img "$wallpaper"
    notify-send "Low Power Mode Disabled"
    killall waybar && waybar
}

# Main script logic
if [ -e "$state_file" ]; then
    disable_low_power_mode
else
    enable_low_power_mode
fi