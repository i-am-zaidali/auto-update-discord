#!/bin/bash

# Check if Discord is installed
if ! dpkg -l discord >/dev/null 2>&1; then
  exit 0  # Don't proceed if Discord isn't installed
fi

# Function to check internet connection
function has_internet() {
  nslookup google.com &> /dev/null
  return $?
}

# Keep trying until internet connection is available
while ! has_internet; do
  sleep 10  # Wait for 1 minute before checking again
done

# Define the URL to download the file from
DOWNLOAD_URL="https://discord.com/api/download/stable?platform=linux&format=deb"

# Define the filename to save the downloaded file
FILE_NAME="discord.deb"

# Define the directory to save the downloaded file
DOWNLOAD_DIR="/tmp"

# checking version so that we dont waste time downloading the same version

# Get current version
cur_version=$(dpkg --status discord | awk '/Version:/ {print $2}' | cut -d' ' -f1)
# Get latest version from the URL
latest_ver="$(echo "$(curl -Ls -I -o /dev/null -w %{url_effective} https://discord.com/api/download/stable?platform=linux&format=deb)" | cut -d'-' -f2 | cut -d'.' -f1-3)"

if [[ "$cur_version" == "$latest_ver" ]]; then
  notify-send "Update Aborted" "Discord is already on the latest version: ${latest_ver}"
  exit 1
fi


# Download the file using wget with error handling
if ! wget -O "$DOWNLOAD_DIR/$FILE_NAME" "$DOWNLOAD_URL"; then
  notify-send "Error" "Failed to download Discord. Aborting installation."
  exit 1
fi


# Install the downloaded file with error handling using dpkg
if ! sudo dpkg -i "$DOWNLOAD_DIR/$FILE_NAME"; then
  # Try installing dependencies if installation fails
  notify-send "Error" "Error installing Discord. Trying to install missing dependencies..."
  sudo apt update && sudo apt install -f
  if ! sudo dpkg -i "$DOWNLOAD_DIR/$FILE_NAME"; then
    notify-send "Error" "Failed to install Discord even after dependency installation."
    exit 1
  fi
fi

# Send a notification only if successful (moved to the end)
notify-send "Updated" "Discord has been updated successfully from ${cur_version} to ${latest_ver}')"
