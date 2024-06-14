#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5
## style-6   style-7   style-8   style-9   style-10

# Current Theme
dir="$HOME/.config/rofi/powermenu"
theme='style'

# Options
options=(
    "󰍁" # Lock
    "󰍃" # Logout
    "󰤄" # Suspend
    "󰜉" # Reboot
    "󰐥" # Shutdown
)
yes='YES'
no='NO'


# Function to run Rofi with specified options
rofi_cmd() {
    rofi -dmenu -theme "${dir}/${theme}.rasi"
}

# Function to run confirmation dialog in Rofi
confirm_cmd() {
    rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?' \
        -theme "${dir}/${theme}.rasi"
}

# Function to ask for confirmation
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

# Function to pass options to Rofi and capture user choice
run_rofi() {
    printf "%s\n" "${options[@]}" | rofi_cmd
}

# Function to execute the selected command
run_cmd() {
    local selected
    selected=$(confirm_exit)
    if [[ "$selected" == "$yes" ]]; then
        case $1 in
            '--shutdown') systemctl poweroff ;;
            '--reboot') systemctl reboot ;;
            '--suspend') systemctl suspend ;;
            '--logout') hyprctl dispatch exit ;;
        esac
    else
        exit 0
    fi
}

# Main script logic
chosen=$(run_rofi)
case $chosen in
    "󰐥") run_cmd --shutdown ;;
    "󰜉") run_cmd --reboot ;;
    "󰍁") hyprlock ;;
    "󰤄") run_cmd --suspend ;;
    "󰍃") run_cmd --logout ;;
esac