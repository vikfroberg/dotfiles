command! SourceVim :source $MYVIMRC
command! Commands :e ~/Code/dotfiles/vim/commands.vim
command! Keys :e ~/Code/dotfiles/vim/keys.vim
command! Mappings :e ~/Code/dotfiles/vim/keys.vim
command! Plugins :e ~/Code/dotfiles/vim/plugins.vim
command! Colors :e ~/Code/dotfiles/vim/colors.vim
command! Settings :e ~/Code/dotfiles/vim/settings.vim
command! Dotfiles :FZF! ~/Code/dotfiles
command! SyntaxAttr :call SyntaxAttr()
command! Diff :w !diff % -
command! Changes :w !diff % -
command! TestFile !py.test %
