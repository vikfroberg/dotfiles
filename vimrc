set nocompatible

filetype plugin indent on

syntax enable
set background=dark

noremap <Space> <NOP>
let mapleader = "\<Space>"

let s:plugin_path = "/Users/vikfroberg/Code/dotfiles/vim/plugins.vim"
execute "source" s:plugin_path
for f in split(glob('~/Code/dotfiles/vim/*.vim'), '\n')
  if f !=# s:plugin_path
    exe 'source' f
  endif
endfor

" colorscheme Base2Tone_EveningDark
