#!/usr/bin/env bash

echo "Bootstrapping..."

~/Developer/dotfiles/install/brew.sh
~/Developer/dotfiles/install/symlink.sh

cat ~/Developer/dotfiles/install/enjoy.txt
