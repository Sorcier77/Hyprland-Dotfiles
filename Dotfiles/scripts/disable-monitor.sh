#!/usr/bin/bash

# Check if the laptop lid is closed by reading the status from /proc/acpi/button/lid/LID/state.
LID_STATUS=$(grep -c "closed" /proc/acpi/button/lid/LID/state)

# Check how many monitors are connected.
MONITOR_COUNT=$(hyprctl monitors | grep -c "Monitor")

# Only proceed if the lid is closed and more than one monitor is connected.
if [ "$LID_STATUS" -eq 1 ] && [ "$MONITOR_COUNT" -gt 1 ]; then
    # Disable the internal monitor.
    hyprctl keyword monitor eDP-1,disable
elif [ "$LID_STATUS" -eq 0 ]; then
    # Enable the internal monitor.
    hyprctl keyword monitor eDP-1,highres,0x1080,1
fi