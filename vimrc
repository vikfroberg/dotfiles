set nocompatible

scriptencoding utf-8
set encoding=utf-8
filetype plugin indent on
syntax enable

" Leader
" ----------------------------
noremap <Space> <NOP>
let mapleader = "\<Space>"

" Plugins
" -----------------------------

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Features
Plug 'ervandew/supertab'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-slash'
Plug 'junegunn/vim-after-object'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'mileszs/ack.vim'
Plug 'matze/vim-move'
Plug 'godlygeek/tabular'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-fugitive'
Plug 'cocopon/vaffle.vim'
Plug 'mattn/webapi-vim'
Plug 'mattn/vim-gist'

" Syntax
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'andys8/vim-elm-syntax'
Plug 'mxw/vim-jsx'
" Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': ['javascript', 'json', 'graphql'] }
" Plug 'neovimhaskell/haskell-vim'
" Plug 'hdima/python-syntax'
" Plug 'leafgarland/typescript-vim'
" Plug 'purescript-contrib/purescript-vim'
call plug#end()


" Settings
" -------------------------------------

set incsearch
set hlsearch
set ignorecase
set smartindent
set smartcase
set cursorline
set nocursorcolumn
set shiftwidth=2
set nonumber
set norelativenumber
set numberwidth=8
set tabstop=2
set softtabstop=2
set expandtab
set laststatus=2
set conceallevel=0
set ttyfast
set lazyredraw
set list
set listchars=nbsp:¬
set autoindent
set backspace=indent,eol,start
set scrolloff=7
set showmatch
set splitbelow
set nosplitright
set ttimeout
set ttimeoutlen=20
set notimeout
set history=500
set noshowmode
set noshowcmd
set mouse=i
set visualbell
set t_vb=
set autoread
set hidden
set encoding=utf8
set nobackup
set nowb
set noswapfile
set nowrap
set clipboard+=unnamed
set iskeyword+=
set iskeyword+=-
set guifont=Monaco:h14
set undodir=~/.vim/undodir
set undofile 


" More sane html idention
let g:html_indent_tags = 'li\|p'

" Show matching paren
let g:loaded_matchparen = 1

" supertab.vim
let g:SuperTabDefaultCompletionType = "<C-n>"

" ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep -s'
endif

" vim-multiple-cursors
let g:multi_cursor_exit_from_insert_mode = 0

" vim-json
let g:vim_json_syntax_conceal = 0

" vim-jsx
let g:jsx_ext_required = 0

" vim-move
" let g:move_key_modifier = 'C'

" elm-vim
let g:elm_format_autosave = 0

" vim-prettier
let g:prettier#config#single_quote = 'false'
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#jsx_bracket_same_line = 'false'
let g:prettier#config#trailing_comma = 'all'
let g:prettier#autoformat = 0

" vim-vaffle
let g:vaffle_force_delete = 1
let g:vaffle_use_default_mappings = 0


" vim-fzf
let $FZF_DEFAULT_OPTS = '--reverse --color 16'


" Auto commands
" ----------------------------------

autocmd VimEnter * call after_object#enable('=', ':', '-', '#', ' ', ',')

augroup vimrc
  autocmd!
  " Create directories on write
  autocmd BufWritePre * :call MkNonExDir(expand('<afile>'), +expand('<abuf>'))

  " Don't add comment when using o/O
  autocmd FileType * setlocal formatoptions-=o

  " Run prettier on save
  " autocmd BufWritePre *.js,*.jsx Prettier

  " Strip whitespace
  " Disabled because it makes bad diffs when used at WH
  " autocmd BufWritePre * :call Preserve("%s/\\s\\+$//e")

  " http://vim.wikia.com/wiki/Highlight_unwanted_spaces
  au BufNewFile,BufRead,InsertLeave * silent! match ExtraWhitespace /\s\+$/
  au InsertEnter * silent! match ExtraWhitespace /\s\+\%#\@<!$/

  " Unset paste on InsertLeave
  autocmd InsertLeave * silent! set nopaste

  " Source vimrc on save
  autocmd BufWritePost .vimrc source %
  autocmd BufWritePost vimrc source %

  " Set indention for langs
  autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType elm setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType purescript setlocal ts=4 sts=4 sw=4 expandtab

  " Set lang for file types
  autocmd BufRead,BufNewFile *.nunjs setfiletype html
  autocmd BufRead,BufNewFile *.eslintrc setfiletype json
  autocmd BufRead,BufNewFile *.babelrc setfiletype json
  autocmd BufRead,BufNewFile bashrc setfiletype sh
  autocmd BufRead,BufNewFile bash_profile setfiletype sh
augroup END


" Appearance
" ---------------------------------

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Set spacing between lines
set linespace=3

" Netrw
hi! link netrwClassify Directory

" Elm
hi! link elmAlias Statement
hi! link elmBraces Normal
hi! link elmCaseBlockDefinition Statement
hi! link elmCaseBlockItemDefinition Statement
hi! link elmChar String
hi! link elmComment Comment
hi! link elmConditional Statement
hi! link elmDebug Debug
hi! link elmDelimiter Delimiter
hi! link elmFloat Float
hi! link elmFuncName Function
hi! link elmImport Include
hi! link elmInt Number
hi! link elmLambdaFunc Normal
hi! link elmLetBlockDefinition Statement
hi! link elmLineComment Comment
hi! link elmModule Type
hi! link elmNumberType Identifier
hi! link elmOperator Operator
hi! link elmString String
hi! link elmStringEscape Special
hi! link elmTodo Todo
hi! link elmTopLevelDecl Function
hi! link elmTripleString String
hi! link elmTupleFunction Normal
hi! link elmType Identifier
hi! link elmType Type
hi! link elmTypedef Statement

" Javascript
hi! link jsVariableDef     Constant
hi! link jsArrowFunction Normal


" Commands
" ------------------------------

command! Dotfiles :FZF! ~/dotfiles
command! Diff :w !diff % -
command! W write|bdelete

command! Gconflicts :call GitConflicts()
command! GConflicts :call GitConflicts()
function! GitConflicts()
  :cexpr system('ag "<<<<" --vimgrep') | copen
endfunction

command! Todos :call Todos()
function! Todos()
  :cexpr system('ag "TODO:" --vimgrep') | copen
endfunction

command! GitMRUFiles :call s:mru_files()

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%')
  \                         : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \                 <bang>0)

command! -bang -nargs=* ElmAgFunctions
  \ call fzf#vim#ag('^[a-z][a-zA-Z_0-9]*\s:',
  \                 <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%')
  \                         : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \                 <bang>0)

command! -bang -nargs=* ElmAgTypes
  \ call fzf#vim#ag('^type',
  \                 <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%')
  \                         : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \                 <bang>0)

command! -bang -nargs=* ElmBufferFunctions
  \ call fzf#vim#buffer_lines('^[a-z][a-zA-Z_0-9]*\s:', <bang>0)

command! -bang -nargs=* ElmBufferTypes
  \ call fzf#vim#buffer_lines('^type', <bang>0)

command! -bang -nargs=* ElmBufferOverview
  \ call fzf#vim#buffer_lines('^type\|^[a-z][a-zA-Z0-9_]*\s:', <bang>0)
  " \ call fzf#vim#buffer_lines('^\s*[{,]\s[a-z][a-zA-Z0-9_]*\s:\|^type\|^\s*[=|]\s[A-Z]\|^[a-z][a-zA-Z0-9_]*\s:', <bang>0)



" Key bindings
" -------------------------------

" Sane ^/$ for swedish keyboard
nnoremap B ^
onoremap B ^
vnoremap B ^
nnoremap E $
onoremap E $
vnoremap E $

" More sane redo
nnoremap U <C-R>

" Make c/d/v/y more consistent
nnoremap V v$h
vnoremap v V
nnoremap Y y$
vnoremap y ygv<Esc>

" Reverse repeat action 
" Makes more sense on a swedish keyboard
nnoremap , ;
nnoremap ; ,

" Save and quit hotkeys
nnoremap s :w<CR>
nnoremap S :wq<CR>
nnoremap q :bw<CR>
nnoremap Q :q<CR>

" Hotkeys for quotes
onoremap iq i"
vnoremap iq i"
onoremap q i"
vnoremap q i"

" Set paste mode for when copying
nnoremap gp :set paste<CR>

" Vim commentary
nmap \ gcc
vmap \ gc

" Move display lines instead of physical line
nnoremap j gj
nnoremap k gk

" Join hotkeys
nnoremap gj J

" Quick navigation 
noremap J 5j
noremap K 5k

" Go forward in nav history
nnoremap <C-l> <Tab> 

" Navigate quickfix
nnoremap <C-h> :cclose<CR>
map <C-j> :cn<CR> 
map <C-k> :cp<CR>

" Tabs
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv


nnoremap - :Vaffle<CR>

function! s:customize_vaffle_mappings() abort
  nmap <buffer> <Tab> <Plug>(vaffle-toggle-current)k
  vmap <buffer> <Tab> <Plug>(vaffle-toggle-current)
  nmap <buffer> - <Plug>(vaffle-open-parent)
  nmap <buffer> <CR> <Plug>(vaffle-open-current)
  nmap <buffer> m <Plug>(vaffle-move-selected)
  nmap <buffer> d <Plug>(vaffle-delete-selected)
  nmap <buffer> r <Plug>(vaffle-rename-selected)
  nmap <buffer> q <Plug>(vaffle-quit)
  nmap <buffer> o <Plug>(vaffle-mkdir)
  nmap <buffer> i <Plug>(vaffle-new-file)
  nmap <buffer> x <Plug>(vaffle-fill-cmdline)
  nmap <buffer> . <Plug>(vaffle-toggle-hidden)
endfunction

augroup vimrc_vaffle
  autocmd!
  autocmd FileType vaffle call s:customize_vaffle_mappings()
augroup END


" Leader mappings
" ----------------------------------

nnoremap <leader>p :GitMRUFiles<CR>
nnoremap <leader>f :BLines!<CR>
nnoremap <leader>F :Ag!<CR>
nnoremap <leader>o :BTags!<CR>
nnoremap <leader>O :Tags!<CR>
nnoremap <leader>n *
nnoremap <leader>N :Ag! <C-R><C-W><CR>
nnoremap <leader>d :tag <C-R><C-W><CR>


" Statusline
" --------------------------------------------

" :h mode() to see all modes
let g:currentmode={
    \ 'n'      : 'Normal ',
    \ 'no'     : 'N·Operator Pending ',
    \ 'v'      : 'Visual ',
    \ 'V'      : 'Visual ',
    \ '\<C-V>' : 'V·Block ',
    \ 's'      : 'Select ',
    \ 'S'      : 'S·Line ',
    \ '\<C-S>' : 'S·Block ',
    \ 'i'      : 'Insert ',
    \ 'R'      : 'Replace ',
    \ 'Rv'     : 'V·Replace ',
    \ 'c'      : 'Command ',
    \ 'cv'     : 'Vim Ex ',
    \ 'ce'     : 'Ex ',
    \ 'r'      : 'Prompt ',
    \ 'rm'     : 'More ',
    \ 'r?'     : 'Confirm ',
    \ '!'      : 'Shell ',
    \ 't'      : 'Terminal '
    \}

" Automatically change the statusline color depending on mode
function! ChangeStatuslineColor()
  if (mode() =~# '\v(n|no)')
    exe 'hi! StatusLine ctermbg=8 ctermfg=0'
  elseif (mode() =~# '\v(v|V)')
    exe 'hi! StatusLine ctermbg=2 ctermfg=0'
  elseif (mode() ==# 'i')
    exe 'hi! StatusLine ctermbg=4 ctermfg=0'
  else
    exe 'hi! StatusLine ctermbg=3 ctermfg=0'
  endif
  return ''
endfunction

" Set the statusline
set laststatus=2
set statusline=
set statusline+=%{ChangeStatuslineColor()} " Changing the statusline color
set statusline+=%0*\ %{toupper(g:currentmode[mode()])} " Current mode
set statusline+=%8*\ %<%f\ " File+path
set statusline+=%9*\ %= " Space
set statusline+=%0*\ %3p%%\ %l#\ " Rownumber/total (%)


" Custom FZF Git MRU 
" ------------------------------

let g:fzf_mru_files = get(g:, 'fzf_mru_files', [])

function! s:update_mru_files(filename)
  if filereadable(a:filename)
    let filename = fnamemodify(a:filename, ":~:.")
    call filter(g:fzf_mru_files, 'v:val !=# filename')
    call add(g:fzf_mru_files, filename)
  endif
endfunction

function! s:delete_mru_files(filename)
  let filename = fnamemodify(a:filename, ":~:.")
  call filter(g:fzf_mru_files, 'v:val !=# filename')
endfunction

augroup fzf_mru_files
  autocmd!
  autocmd BufWritePost * call s:update_mru_files(expand('%'))
  autocmd BufEnter * call s:update_mru_files(expand('%'))
  autocmd BufReadPost * call s:update_mru_files(expand('%'))
  autocmd BufDelete * call s:delete_mru_files(expand('%'))
augroup END

function! s:mru_files(...)
  let mru = reverse(copy(g:fzf_mru_files))
  let files = sort(split(system('ag -l')))
  let relative_mru = filter(copy(mru), 'index(files, v:val) != -1')
  let current_filename = fnamemodify(expand('%'), ":~:.")
  let relative_mru_without_current = filter(copy(relative_mru), 'v:val !=# current_filename')
  let files_without_mru = filter(copy(files), 'index(relative_mru, v:val) == -1')
  let source = extend(relative_mru_without_current, files_without_mru)
  return fzf#run({ 'source': source, 'sink': 'e', 'options': '--color 16 --no-sort --exact'})
endfunction


" HL | Find out syntax group
" -------------------------------------

function! s:hl()
  " echo synIDattr(synID(line('.'), col('.'), 0), 'name')
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')
endfunction
command! HL call <SID>hl()


" Helpers
" -------------------------------------

function! Preserve(command)
  let _s=@/
  let l = line(".")
  let c = col(".")
  execute a:command
  let @/=_s
  call cursor(l, c)
endfunction

function! MkNonExDir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction
