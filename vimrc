set nocompatible

scriptencoding utf-8
set encoding=utf-8
filetype plugin indent on
syntax enable
set background=dark

noremap <Space> <NOP>
let mapleader = "\<Space>"

execute "source" "~/dotfiles/vim/plugins.vim"
execute "source" "~/dotfiles/vim/autocmd.vim"
execute "source" "~/dotfiles/vim/commands.vim"
execute "source" "~/dotfiles/vim/keys.vim"
execute "source" "~/dotfiles/vim/settings.vim"
execute "source" "~/dotfiles/vim/colors.vim"
execute "source" "~/dotfiles/vim/local.vim"

