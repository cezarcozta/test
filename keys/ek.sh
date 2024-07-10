#!/bin/bash
echo "Running evalkey.sh script..."
# Directory containing SSH keys
SSH_DIR="$HOME/.ssh"

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <ssh-key-filename>"
  echo "Listing all files in $SSH_DIR:"
  ls -1 $SSH_DIR | grep -E '^[^.]+$'
  exit 1
fi

# SSH key filename passed as the first argument
SSH_KEY_FILENAME=$1

# Start the ssh-agent in the background
eval "$(ssh-agent -s)"

# Add the specified SSH private key to the ssh-agent
ssh-add ~/.ssh/$SSH_KEY_FILENAME

# Optionally, you can print a message to confirm the operations
echo "ssh-agent started and SSH key ~/.ssh/$SSH_KEY_FILENAME added."

