#!/usr/bin/env bash

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print messages
print_message() {
    echo -e "${1}${2}${NC}"
}

# Function to check environment requirements
checkEnv() {
	## Check if the current directory is writable.
    GITPATH="$(dirname "$(realpath "$0")")"
    if [[ ! -w ${GITPATH} ]]; then
        print_message "${RED}" "Can't write to ${GITPATH}"
        exit 1
    fi
}

## Function to create backup and link files
link_file() {
    local src=$1
    local dest=$2
    local backup="${dest}.bak"

    ## Create destination directory if it doesn't exist
    mkdir -p "$(dirname "${dest}")"

    ## Check if the destination file exists and move to backup
    if [[ -e ${dest} ]]; then
        print_message "${YELLOW}" "Moving old config file ${dest} to ${backup}"
        if ! mv "${dest}" "${backup}"; then
            print_message "${RED}" "Can't move the old config file ${dest}!"
            exit 1
        fi
    fi

    ## Make symbolic link
    print_message "${YELLOW}" "Linking new config file ${src} to ${dest}"
    ln -svf "${src}" "${dest}"
}

# Function to link dotfiles and scripts
linkDots() {
    ## Get the correct user home directory.
    USER_HOME=$(getent passwd "${SUDO_USER:-$USER}" | cut -d: -f6)

    ## Define the dotfiles and their destinations.
    declare -A dotfiles=(
        [ "${GITPATH}/Dotfiles/hypr/hypridle.conf"]="${USER_HOME}/.config/hypr/hypridle.conf"
        [ "${GITPATH}/Dotfiles/hypr/hyprland.conf"]="${USER_HOME}/.config/hypr/hyprland.conf"
        [ "${GITPATH}/Dotfiles/hypr/hyprlock.conf"]="${USER_HOME}/.config/hypr/hyprlock.conf"
        [ "${GITPATH}/Dotfiles/kitty/kitty.conf"]="${USER_HOME}/.config/kitty/kitty.conf"
        [ "${GITPATH}/Dotfiles/mako/config"]="${USER_HOME}/.config/mako/config"
        [ "${GITPATH}/Dotfiles/rofi/launcher/launcher.sh"]="${USER_HOME}/.config/rofi/launcher/launcher.sh"
        [ "${GITPATH}/Dotfiles/rofi/launcher/style.rasi"]="${USER_HOME}/.config/rofi/launcher/style.rasi"
        [ "${GITPATH}/Dotfiles/rofi/powermenu/powermenu.sh"]="${USER_HOME}/.config/rofi/powermenu/powermenu.sh"
        [ "${GITPATH}/Dotfiles/rofi/powermenu/style.rasi"]="${USER_HOME}/.config/rofi/powermenu/style.rasi"
        [ "${GITPATH}/Dotfiles/waybar/config.jsonc"]="${USER_HOME}/.config/waybar/config.jsonc"
        [ "${GITPATH}/Dotfiles/waybar/style.css"]="${USER_HOME}/.config/waybar/style.css"
    )

    ## Define the scripts and their destinations
    declare -A scripts=(
        [ "${GITPATH}/Dotfiles/disable-monitor.sh"]="${USER_HOME}/.config/scripts/disable-monitor.sh"
        [ "${GITPATH}/Dotfiles/git-obsidian.sh"]="${USER_HOME}/.config/scripts/git-obsidian.sh"
        [ "${GITPATH}/Dotfiles/low-power.sh"]="${USER_HOME}/.config/scripts/low-power.sh"
        [ "${GITPATH}/Dotfiles/xp-pen/cycle-colors.sh"]="${USER_HOME}/.config/scripts/xp-pen/cycle-colors.sh"
        [ "${GITPATH}/Dotfiles/xp-pen/cycle-workspaces.sh"]="${USER_HOME}/.config/scripts/xp-pen/cycle-workspaces.sh"
    )

    ## Link dotfiles
    for src in "${!dotfiles[@]}"; do
        link_file "${src}" "${dotfiles[$src]}"
    done

    ## Link custom scripts
    for src in "${!scripts[@]}"; do
        link_file "${src}" "${scripts[$src]}"
    done
}

checkEnv

if linkDots; then
    print_message "${GREEN}" "All dotfiles and scripts linked successfully!"
else
    print_message "${RED}" "Something went wrong!"
fi