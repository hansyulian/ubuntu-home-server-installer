#!/bin/bash

# Check if .env file exists
if [ -f ".env" ]; then
    # Load environment variables from .env
    echo "Loading environment variables from .env..."
    export $(grep -v '^#' .env | xargs)
else
    echo ".env file not found. Please create it based on the .env.example file."
    exit 1
fi

# Source the functions script
echo "Loading functions from functions.sh..."
source lib/functions.sh
source lib/install_packages.sh

# Add environment variables to /etc/environment
add_to_environment HANYALISTI_MOUNT_PATH "$HANYALISTI_MOUNT_PATH"
add_to_environment HANS_LOG_FOLDER "$HANS_LOG_FOLDER"
add_to_environment HANYALISTI_TRANSMISSION_USERNAME "$HANYALISTI_TRANSMISSION_USERNAME"
add_to_environment HANYALISTI_TRANSMISSION_PASSWORD "$HANYALISTI_TRANSMISSION_PASSWORD"
add_to_environment HANYALISTI_TRANSMISSION_DIRECTORY "$HANYALISTI_TRANSMISSION_DIRECTORY"

add_to_path "/opt/scripts"

add_to_bashrc "~/.hansrc"
add_to_bashrc "~/.hansloginrc"


source ~/.bashrc

install_packages
configure_system