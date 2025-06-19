#!/usr/bin/env bash

CYAN='\033[0;36m'
NC='\033[0m'

function resetScreen() {
  clear
  echo -e "${CYAN}"
  echo "    ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗"
  echo "    ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝"
  echo "    ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗"
  echo "    ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║"
  echo "    ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║"
  echo "    ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝"
  echo -e "${NC}"
  echo
}

# INSTALL BREW
# ------------
resetScreen
read -p "Install Homebrew? [Y/n]: " REPLY
REPLY=${REPLY:-Y}
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    if test ! $(which brew); then
      echo "Downloading and installing Homebrew..."
      # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
      echo "Homebrew is already installed, skipping..."
    fi
  fi
echo
read -p "Press enter to continue"

# UPDATE BREW
# -----------
resetScreen
read -p "Update brew? (Y/n): " REPLY
REPLY=${REPLY:-Y}
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    if test ! $(which brew); then
      echo "Homebrew is not installed, skipping update..."
      exit 1
    else
      echo "Updating Homebrew..."
      # brew update
    fi
  fi
echo
read -p "Press enter to continue"

# PACKAGES
# --------
resetScreen
PACKAGES=(
    git
    node
    fzf
    fd
    ag
    ripgrep
    neovim
    python
    coreutils
)

PACKAGES_TO_INSTALL=()
for package in ${PACKAGES[@]}; do
    read -p "Install $package? (Y/n): " REPLY
      REPLY=${REPLY:-Y}
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        PACKAGES_TO_INSTALL+=($package)
      fi
done

for package in ${PACKAGES_TO_INSTALL[@]}; do
    echo "Installing $package..."
    # brew install $package
done
echo
read -p "Press enter to continue"

# SYMLINK
# -------
resetScreen
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
files=$(find "$DOTFILES_DIR" -maxdepth 1 -name ".*" -type f -exec basename {} \;)

read -p "Create symlinks? (Y/n): " REPLY
  REPLY=${REPLY:-Y}
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    echo "Moving existing dotfiles to ~/.dotfiles_old..."
    mkdir -p ~/.dotfiles_bak
    rm -rf ~/.dotfiles_bak/*
    for file in $files; do
       mv ~/$file ~/.dotfiles_bak/$file 2>/dev/null
    done
    mv ~/.config/nvim ~/.dotfiles_bak/nvim 2>/dev/null

    echo "Creating symlinks..."
    for file in $files; do
      ln -s "$DOTFILES_DIR/$file" ~/$file
    done
    ln -s "$DOTFILES_DIR/nvim" ~/.config/nvim
  fi
echo
read -p "Press enter to continue"

resetScreen
echo "✅ Installation complete!"

# Check if zsh version is present from $ZSH_VERSION
if [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
fi

if [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc
fi
