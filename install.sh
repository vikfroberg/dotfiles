#!/usr/bin/env bash

echo "Bootstrapping..."

~/dotfiles/install/brew.sh
~/dotfiles/install/npm.sh
~/dotfiles/install/symlink.sh
~/dotfiles/install/base16.sh

cat ~/dotfiles/install/enjoy.txt
