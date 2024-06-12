#!/bin/bash

if ! dpkg -l discord >/dev/null 2>&1; then
    notify-send "No discord found" "It seems discord isn't installed"
    exit 0
fi

DOWNLOAD_URL="https://discord.com/api/download/stable?platform=linux&format=deb"

FILE_NAME="discord.deb"

DOWNLOAD_DIR="/tmp"

cur_version=$(dpkg --status discord | awk '/Version:/ {print $2}' | cut -d' ' -f1)
latest_ver="$(echo "$(curl -Ls -I -o /dev/null -w '%{url_effective}' https://discord.com/api/download/stable?platform=linux\&format=deb)" | cut -d'-' -f2 | cut -d'.' -f1-3)"

if ! dpkg --compare-versions "$latest_ver" gt "$cur_version"; then
    notify-send "Update Aborted" "Discord is already on the latest version: ${latest_ver}" -a discord
    exit 0
fi

if dpkg-deb --info "$DOWNLOAD_DIR/$FILE_NAME"; then
    DOWNLOADED_VER=$(dpkg --info "$DOWNLOAD_DIR/$FILE_NAME" | awk '/Version:/ {print $2}' | cut -d' ' -f1)
else
    DOWNLOADED_VER="0.0.0"
fi

if [ ! -f "$DOWNLOAD_DIR/$FILE_NAME" ] || dpkg --compare-versions "$latest_ver" gt "$DOWNLOADED_VER"; then
    notify-send "Downloading" "Couldn't find an existing download of discord's latest deb package. Downloading from website now."
    if ! wget -v -O "$DOWNLOAD_DIR/$FILE_NAME" "$DOWNLOAD_URL"; then
        notify-send "Error" "Failed to download Discord. Aborting installation."
        exit 1
    fi
fi

notify-send "File already exists" "Discord's debian package of version ${latest_ver} already exists. Installing that"

if ! sudo dpkg -i "$DOWNLOAD_DIR/$FILE_NAME"; then
    notify-send "Error" "Error installing Discord. Trying to install missing dependencies..."
    sudo apt update && sudo apt install -f
    if ! sudo dpkg -i "$DOWNLOAD_DIR/$FILE_NAME"; then
        notify-send "Error" "Failed to install Discord even after dependency installation."
        exit 1
    fi
fi

notify-send "Updated" "Discord has been updated successfully from ${cur_version} to ${latest_ver}" -a discord
exit 0
