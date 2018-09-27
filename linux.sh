#!/usr/bin/env bash

echo "Starting..."

# Check for Linuxbrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing Linuxbrew..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
fi

# Update homebrew recipes
echo "Updating Linuxbrew..."
brew update

# Installs
echo "Installing programs..."
brew install bash
brew install node
brew install vim
brew install tree
brew install fzf

echo "Installing node modules"
sudo npm install -g ramda-cli
