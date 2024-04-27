#!/bin/bash

if ! dpkg -l discord >/dev/null 2>&1; then
  exit 0
fi

function has_internet() {
  nslookup google.com &> /dev/null
  return $?
}

while ! has_internet; do
  sleep 10
done

DOWNLOAD_URL="https://discord.com/api/download/stable?platform=linux&format=deb"

FILE_NAME="discord.deb"

DOWNLOAD_DIR="/tmp"

cur_version=$(dpkg --status discord | awk '/Version:/ {print $2}' | cut -d' ' -f1)

latest_ver="$(echo "$(curl -Ls -I -o /dev/null -w %{url_effective} https://discord.com/api/download/stable?platform=linux&format=deb)" | cut -d'-' -f2 | cut -d'.' -f1-3)"

if [[ "$cur_version" == "$latest_ver" ]]; then
  notify-send "Update Aborted" "Discord is already on the latest version: ${latest_ver}"
  exit 1
fi


if ! wget -O "$DOWNLOAD_DIR/$FILE_NAME" "$DOWNLOAD_URL"; then
  notify-send "Error" "Failed to download Discord. Aborting installation."
  exit 1
fi


if ! sudo dpkg -i "$DOWNLOAD_DIR/$FILE_NAME"; then
  notify-send "Error" "Error installing Discord. Trying to install missing dependencies..."
  sudo apt update && sudo apt install -f
  if ! sudo dpkg -i "$DOWNLOAD_DIR/$FILE_NAME"; then
    notify-send "Error" "Failed to install Discord even after dependency installation."
    exit 1
  fi
fi

notify-send "Updated" "Discord has been updated successfully from ${cur_version} to ${latest_ver}')"
