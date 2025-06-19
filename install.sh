#!/usr/bin/env bash

echo "Bootstrapping..."

~/Developer/dotfiles/install/brew.sh
~/Developer/dotfiles/install/symlink.sh
~/Developer/dotfiles/install/base16.sh

cat ~/Developer/dotfiles/install/enjoy.txt
