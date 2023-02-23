#!/bin/sh

set -e

# Install Homebrew
if [ -e /opt/homebrew/bin/brew ] || [ -e /usr/local/bin/brew ]; then
    printf "\n Homebrew already installed."
else
    printf "\n Installing Homebrew..."
fi
