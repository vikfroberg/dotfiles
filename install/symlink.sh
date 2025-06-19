# Create symbolic links

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Auto-discover dotfiles (files starting with .)
files=$(find "$DOTFILES_DIR" -maxdepth 1 -name ".*" -type f -exec basename {} \;)

echo "Moving existing dotfiles to ~/.dotfiles_old..."
mkdir -p ~/.dotfiles_bak
rm -rf ~/.dotfiles_bak/*

for file in $files; do
    mv ~/$file ~/.dotfiles_bak/$file 2>/dev/null
done
mv ~/.config/nvim ~/.dotfiles_bak/nvim 2>/dev/null

echo "Creating symlinks for dotfiles..."
for file in $files; do
    ln -s "$DOTFILES_DIR/$file" ~/$file
done

echo "Creating symlinks for nvim..."
ln -s "$DOTFILES_DIR/nvim" ~/.config/nvim

echo "All done!"


# Check if zsh version is present from $ZSH_VERSION
if [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
fi

if [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc
fi
