echo "Bootstrapping..."

# Check for Linuxbrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing Linuxbrew..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    sudo apt-get install build-essential curl file git
fi

~/dotfiles/install/brew.sh
~/dotfiles/install/symlink.sh
~/dotfiles/install/base16.sh

cat ~/dotfiles/install/enjoy.txt
