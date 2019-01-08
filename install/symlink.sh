# Create symbolic links

files="bash_profile bashrc vimrc gitconfig gitmessage gitignore"

echo "Moving existing dotfiles to ~/.dotfiles_old..."
mkdir -p ~/.dotfiles_old
rm -rf ~/.dotfiles_old/*

for file in $files; do
    mv ~/.$file ~/.dotfiles_old/.$file 2>/dev/null
done

echo "Creating symlinks for dotfiles..."
for file in $files; do
    ln -s ~/dotfiles/$file ~/.$file
done

source ~/.bash_profile
