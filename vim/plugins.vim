if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

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
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-surround'
Plug 'ervandew/supertab'
" Plug 'kana/vim-textobj-user'
" Plug 'beloglazov/vim-textobj-quotes'
" Plug 'michaeljsmith/vim-indent-object'
Plug 'vim-scripts/SyntaxAttr.vim'
Plug 'tpope/vim-eunuch'
" Plug 'AndrewRadev/splitjoin.vim'
" Plug 'tpope/vim-fugitive'
" Plug 'w0rp/ale'
Plug 'ElmCast/elm-vim'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql'] }
call plug#end()

