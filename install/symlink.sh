# Create symbolic links

files="zshrc bashrc profile gitconfig gitmessage gitignore"

echo "Moving existing dotfiles to ~/.dotfiles_old..."
mkdir -p ~/.dotfiles_old
rm -rf ~/.dotfiles_old/*

for file in $files; do
    mv ~/.$file ~/.dotfiles_old/.$file 2>/dev/null
done

echo "Creating symlinks for dotfiles..."
for file in $files; do
    ln -s ~/Code/vikfroberg/dotfiles/$file ~/.$file
done

echo "Creating symlinks for nvim..."
ln -s ~/Code/vikfroberg/dotfiles/nvim ~/.config/nvim


# Check if zsh version is present from $ZSH_VERSION
if [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
fi

if [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc
fi
