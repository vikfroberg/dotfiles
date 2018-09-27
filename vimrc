set nocompatible

scriptencoding utf-8
set encoding=utf-8

filetype plugin indent on

syntax enable
set background=dark

noremap <Space> <NOP>
let mapleader = "\<Space>"

let s:plugin_path = "~/dotfiles/vim/plugins.vim"
execute "source" s:plugin_path
for f in split(glob('~/dotfiles/vim/*.vim'), '\n')
  if f !=# s:plugin_path
    exe 'source' f
  endif
endfor

" Fix Ag for fzf
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

