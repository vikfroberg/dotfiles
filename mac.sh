#!/usr/bin/env bash

echo "Starting..."

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

# Installs
echo "Installing brew programs..."
brew install bash
brew install node
brew install vim
brew install tree
brew install fzf

echo "Installing node modules"
sudo npm install -g ramda-cli
