# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update homebrew recipes
echo "Updating Homebrew..."
brew update

# Installs
echo "Installing brew packages..."
brew install git
brew install node
brew install fzf
brew install fd
brew install ag
brew install neovim
brew install python
brew install coreutils
