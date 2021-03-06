#!/usr/bin/env bash

echo "Bootstrapping..."

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing Homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

~/dotfiles/install/brew.sh
~/dotfiles/install/symlink.sh
~/dotfiles/install/base16.sh

cat ~/dotfiles/install/enjoy.txt
