echo "Bootstrapping..."

# Check for Linuxbrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing Linuxbrew..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
fi

~/dotfiles/install/brew.sh
sudo apt install silversearcher-ag
~/dotfiles/install/symlink.sh

cat ~/dotfiles/install/enjoy.txt
