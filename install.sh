#!/usr/bin/env bash

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Track what gets installed/configured
INSTALLED_BREW=false
UPDATED_BREW=false
INSTALLED_PACKAGES=()
CREATED_SYMLINKS=false
SYMLINKED_FILES=()

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
echo -e "${BLUE}🍺 Homebrew Installation${NC}"
echo
read -p "Install Homebrew? [Y/n]: " REPLY
REPLY=${REPLY:-Y}
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    if test ! $(which brew); then
      echo -e "${YELLOW}📥 Downloading and installing Homebrew...${NC}"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      INSTALLED_BREW=true
    else
      echo -e "${GREEN}✅ Homebrew is already installed, skipping...${NC}"
    fi
  fi
echo
read -p "Press enter to continue"

# UPDATE BREW
# -----------
resetScreen
echo -e "${BLUE}🔄 Homebrew Update${NC}"
echo
read -p "Update brew? (Y/n): " REPLY
REPLY=${REPLY:-Y}
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    if test ! $(which brew); then
      echo -e "${RED}❌ Homebrew is not installed, skipping update...${NC}"
      exit 1
    else
      echo -e "${YELLOW}🔄 Updating Homebrew...${NC}"
      brew update
      UPDATED_BREW=true
    fi
  fi
echo
read -p "Press enter to continue"

# PACKAGES
# --------
resetScreen
echo -e "${BLUE}📦 Package Installation${NC}"
echo
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
    read -p "📦 Install $package? (Y/n): " REPLY
      REPLY=${REPLY:-Y}
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        PACKAGES_TO_INSTALL+=($package)
      fi
done

echo
for package in ${PACKAGES_TO_INSTALL[@]}; do
    echo -e "${YELLOW}📦 Installing $package...${NC}"
    brew install $package
    INSTALLED_PACKAGES+=($package)
done
echo
read -p "Press enter to continue"

# SYMLINK
# -------
resetScreen
echo -e "${BLUE}🔗 Dotfiles Symlink Setup${NC}"
echo
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

# Get all dotfiles, then filter out gitignored ones
all_files=$(find . -maxdepth 1 -name ".*" -type f -exec basename {} \;)
files=""

for file in $all_files; do
    # Skip if file is gitignored
    if ! git check-ignore "$file" >/dev/null 2>&1; then
        files="$files $file"
    fi
done

read -p "🔗 Create symlinks? (Y/n): " REPLY
  REPLY=${REPLY:-Y}
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    echo -e "${YELLOW}💾 Moving existing dotfiles to ~/.dotfiles_bak...${NC}"
    mkdir -p ~/.dotfiles_bak
    rm -rf ~/.dotfiles_bak/*
    for file in $files; do
       mv ~/$file ~/.dotfiles_bak/$file 2>/dev/null
    done
    mv ~/.config/nvim ~/.dotfiles_bak/nvim 2>/dev/null

    echo
    echo -e "${YELLOW}🔗 Creating symlinks...${NC}"
    for file in $files; do
      ln -s "$DOTFILES_DIR/$file" ~/$file
      SYMLINKED_FILES+=("$file")
    done
    ln -s "$DOTFILES_DIR/nvim" ~/.config/nvim
    SYMLINKED_FILES+=("~/.config/nvim")
    CREATED_SYMLINKS=true
  fi
echo
read -p "Press enter to continue"

resetScreen
echo -e "${GREEN}🎉 Installation Complete!${NC}"
echo
echo -e "${CYAN}📋 Installation Summary:${NC}"
echo -e "${CYAN}========================${NC}"

# Homebrew Summary
if [ "$INSTALLED_BREW" = true ]; then
    echo -e "${GREEN}✅ Homebrew installed${NC}"
elif [ "$UPDATED_BREW" = true ]; then
    echo -e "${GREEN}✅ Homebrew updated${NC}"
else
    echo -e "${YELLOW}⏭️  Homebrew skipped${NC}"
fi

# Packages Summary
if [ ${#INSTALLED_PACKAGES[@]} -gt 0 ]; then
    echo -e "${GREEN}✅ Packages installed (${#INSTALLED_PACKAGES[@]}):${NC}"
    for package in "${INSTALLED_PACKAGES[@]}"; do
        echo -e "   📦 $package"
    done
else
    echo -e "${YELLOW}⏭️  No packages installed${NC}"
fi

# Symlinks Summary
if [ "$CREATED_SYMLINKS" = true ]; then
    echo -e "${GREEN}✅ Dotfiles symlinks created (${#SYMLINKED_FILES[@]}):${NC}"
    for file in "${SYMLINKED_FILES[@]}"; do
        echo -e "   🔗 $file"
    done
    echo -e "   💾 Previous files backed up to ~/.dotfiles_bak"
else
    echo -e "${YELLOW}⏭️  Symlinks skipped${NC}"
fi

echo
echo -e "${GREEN}🚀 Your development environment is ready!${NC}"
echo

# Check if zsh version is present from $ZSH_VERSION
if [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
fi

if [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc
fi
