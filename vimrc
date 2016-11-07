" c//e change search
set nocompatible

filetype plugin indent on
syntax on

colorscheme base16-ir-black

" noremap : <NOP>echo "Use leader commands instead"
noremap <Space> <NOP>
let mapleader = "\<Space>"

command! SourceVIMRC :source $MYVIMRC
command! Dotfiles :tabe ~/Code/dotfiles

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'hdima/python-syntax'
Plug 'tpope/vim-commentary'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'mxw/vim-jsx'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'janko-m/vim-test'
Plug 'tweekmonster/fzf-filemru'
Plug 'chaoren/vim-wordmotion'
Plug 'michaeljsmith/vim-indent-object'
call plug#end()

for f in split(glob('~/Code/dotfiles/vim/*.vim'), '\n')
    exe 'source' f
endfor
