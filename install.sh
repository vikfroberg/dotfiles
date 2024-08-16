#!/usr/bin/env bash

echo "Bootstrapping..."

~/Code/vikfroberg/dotfiles/install/brew.sh
~/Code/vikfroberg/dotfiles/install/symlink.sh
~/Code/vikfroberg/dotfiles/install/base16.sh

cat ~/Code/vikfroberg/dotfiles/install/enjoy.txt
