#!/usr/bin/env bash

echo "Bootstrapping..."

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing Homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

~/dotfiles/brew.sh
~/dotfiles/npm-mac.sh
~/dotfiles/symlink.sh

cat ~/dotfiles/enjoy
