set nocompatible

scriptencoding utf-8
set encoding=utf-8
filetype plugin indent on
syntax enable

noremap <Space> <NOP>
let mapleader = "\<Space>"

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'AndrewRadev/splitjoin.vim'
Plug 'ElmCast/elm-vim', { 'do': 'npm i -g elm elm-test elm-format elm-oracle' }
Plug 'elzr/vim-json'
Plug 'ervandew/supertab'
Plug 'guns/xterm-color-table.vim'
Plug 'hdima/python-syntax'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-slash'
Plug 'leafgarland/typescript-vim'
Plug 'mbbill/undotree'
Plug 'mxw/vim-jsx'
Plug 'neovimhaskell/haskell-vim'
Plug 'pangloss/vim-javascript'
Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': ['javascript', 'json', 'graphql'] }
Plug 'purescript-contrib/purescript-vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
" Plug 'tpope/vim-vinegar'
Plug 'vim-scripts/SyntaxAttr.vim'
call plug#end()


set incsearch
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
set iskeyword+=-
set guifont=Monaco:h14

let g:html_indent_tags = 'li\|p'
let g:loaded_matchparen = 1
let g:ackprg = 'ag --vimgrep --smart-case'
let g:multi_cursor_exit_from_insert_mode = 0
let g:vim_json_syntax_conceal = 0
let g:jsx_ext_required = 0

if !exists("g:netrw_banner")
  let g:netrw_banner = 0
endif

" FZF

let $FZF_DEFAULT_OPTS = '--reverse --color 16'
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
  let filename = fnamemodify(expand('%'), ":~:.")
  let relative_mru_without_current = filter(copy(relative_mru), 'v:val !=# filename')
  let files_without_mru = filter(copy(files), 'index(relative_mru, v:val) == -1')
  let source = extend(relative_mru_without_current, files_without_mru)
  return fzf#run({ 'source': source, 'sink': 'e', 'options': '--color 16 --no-sort --exact'})
endfunction

command! GitMRUFiles :call s:mru_files()

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview({'options': '--delimiter :'}, 'right:50%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)


" Lightline

let g:lightline = {
      \ 'colorscheme': 'custom',
      \ 'active': {
      \   'left': [ [ 'filename' ] ],
      \   'right': [ ],
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \ }
      \ }

function! LightlineFilename()
  return expand('%')
endfunction

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [ [15, 0] ]
let s:p.normal.middle = s:p.normal.left
let s:p.normal.right = s:p.normal.left

let s:p.insert.left = [ [8, 2] ]
let s:p.insert.middle = s:p.insert.left
let s:p.insert.right = s:p.insert.left

let s:p.visual.left = [ [8, 15] ]
let s:p.visual.middle = s:p.visual.left
let s:p.visual.right = s:p.visual.left

let s:p.replace.left = [ [8, 1] ]
let s:p.replace.middle = s:p.replace.left
let s:p.replace.right = s:p.replace.left

let s:p.normal.error = [ [8, 1] ]
let s:p.normal.warning = [ [8, 3] ]

let g:lightline#colorscheme#custom#palette = lightline#colorscheme#fill(s:p)

" Elm
let g:elm_format_autosave = 0

" Pretttier
let g:prettier#config#single_quote = 'false'
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#jsx_bracket_same_line = 'false'
let g:prettier#config#trailing_comma = 'all'
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx Prettier

function! Preserve(command)
  let _s=@/
  let l = line(".")
  let c = col(".")
  execute a:command
  let @/=_s
  call cursor(l, c)
endfunction

function! NetrwMapping()
  noremap <buffer> S <NOP>
  noremap <buffer> s <NOP>
  noremap <buffer> q :bd<CR>
  noremap <buffer> Q :q<CR>
endfunction

function! MkNonExDir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction

function! OpenFolder()
  execute "e " . expand('%:p:h')
endfunction

function! OpenRoot()
  execute "e ."
endfunction

function! CloseNetrw()
  execute "bd"
  " let buflen = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
  " if buflen > 0
  "   execute "bd"
  " endif
endfunction

function! Close()
  execute "bd"
  " let bufnr = bufnr('$')
  " let prevbufnr = bufnr('#')
  " if prevbufnr > 0
  "   execute "e#"
  " else
  "   execute "e ."
  " endif
  " execute bufnr . "bw"
endfunction

augroup vimrc
  autocmd!
  " Netrw mappings
  autocmd filetype netrw call NetrwMapping()

  " Netrw hack
  " https://github.com/tpope/vim-vinegar/issues/13#issuecomment-47133890
  autocmd FileType netrw setl bufhidden=delete

  " Create directories on write
  autocmd BufWritePre * :call MkNonExDir(expand('<afile>'), +expand('<abuf>'))

  " Don't add comment when using o/O
  autocmd FileType * setlocal formatoptions-=o

  " Strip whitespace
  autocmd BufWritePre * :call Preserve("%s/\\s\\+$//e")

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
augroup END

hi clear
if exists("syntax_on")
  syntax reset
endif

set background=dark
set linespace=3

hi Normal               cterm=none ctermbg=none     ctermfg=15      gui=none        guibg=#282828   guifg=#F7F7F7
hi LineNr               cterm=none ctermbg=none     ctermfg=8       gui=none        guibg=#282828   guifg=#8F8F8F
hi StatusLine           cterm=none ctermbg=8        ctermfg=15      gui=none        guibg=#5D5D5D   guifg=#FBFBFB
hi StatusLineNC         cterm=none ctermbg=15       ctermfg=8       gui=none        guibg=#5D5D5D   guifg=#FBFBFB
hi Search               cterm=none ctermbg=6        ctermfg=15      gui=none        guibg=#2EB5C1   guifg=#F7F7F7
hi IncSearch            cterm=none ctermbg=3        ctermfg=8       gui=none        guibg=#F6DC69   guifg=#8F8F8F
hi ColumnMargin         cterm=none ctermbg=0                        gui=none        guibg=#000000
hi Error                cterm=none ctermbg=1        ctermfg=15      gui=none                        guifg=#F7F7F7
hi ErrorMsg             cterm=none ctermbg=1        ctermfg=15      gui=none                        guifg=#F7F7F7
hi Folded               cterm=none ctermbg=8        ctermfg=2       gui=none        guibg=#3B3B3B   guifg=#90AB41
hi FoldColumn           cterm=none ctermbg=8        ctermfg=2       gui=none        guibg=#3B3B3B   guifg=#90AB41
hi NonText              cterm=bold ctermbg=none     ctermfg=8       gui=bold                        guifg=#8F8F8F
hi ModeMsg              cterm=bold ctermbg=none     ctermfg=10      gui=none
hi Pmenu                cterm=none ctermbg=8        ctermfg=15      gui=none        guibg=#8F8F8F   guifg=#F7F7F7
hi PmenuSel             cterm=none ctermbg=15       ctermfg=8       gui=none        guibg=#F7F7F7   guifg=#8F8F8F
hi PmenuSbar            cterm=none ctermbg=15       ctermfg=8       gui=none        guibg=#F7F7F7   guifg=#8F8F8F
hi SpellBad             cterm=none ctermbg=1        ctermfg=15      gui=none                        guifg=#F7F7F7
hi SpellCap             cterm=none ctermbg=4        ctermfg=15      gui=none                        guifg=#F7F7F7
hi SpellRare            cterm=none ctermbg=4        ctermfg=15      gui=none                        guifg=#F7F7F7
hi SpellLocal           cterm=none ctermbg=4        ctermfg=15      gui=none                        guifg=#F7F7F7
hi Visual               cterm=none ctermbg=15       ctermfg=8       gui=none        guibg=#F7F7F7   guifg=#8F8F8F
hi Directory            cterm=none ctermbg=none     ctermfg=4       gui=none        guibg=#242424   guifg=#88CCE7
hi SpecialKey           cterm=none ctermbg=none     ctermfg=8       gui=none                        guifg=#8F8F8F
hi DiffAdd              cterm=bold ctermbg=2        ctermfg=15
hi DiffChange           cterm=bold ctermbg=4        ctermfg=15
hi DiffDelete           cterm=bold ctermbg=1        ctermfg=15
hi DiffText             cterm=bold ctermbg=3        ctermfg=8
hi MatchParen           cterm=none ctermbg=6        ctermfg=15      gui=none        guibg=#2EB5C1   guifg=#F7F7F7
hi CursorLine           cterm=none ctermbg=238      ctermfg=none    gui=none        guibg=#424242
hi CursorColumn         cterm=none ctermbg=238      ctermfg=none    gui=none        guibg=#424242
hi Title                cterm=none ctermbg=none     ctermfg=4       gui=none                        guifg=#88CCE7
hi VertSplit            cterm=bold ctermbg=none     ctermfg=8       gui=bold        guibg=#282828   guifg=#8F8F8F
hi SignColumn           cterm=bold ctermbg=none     ctermfg=8       gui=bold        guibg=#282828   guifg=#8F8F8F

" ----------------------------------------------------------------------------
" Syntax Highlighting
" ----------------------------------------------------------------------------
hi Keyword              cterm=none ctermbg=none ctermfg=10          gui=none        guifg=#D1FA71
hi Comment              cterm=none ctermbg=none ctermfg=8           gui=none        guifg=#8F8F8F
hi Delimiter            cterm=none ctermbg=none ctermfg=15          gui=none        guifg=#F7F7F7
hi Identifier           cterm=none ctermbg=none ctermfg=12          gui=none        guifg=#96D9F1
hi Structure            cterm=none ctermbg=none ctermfg=12          gui=none        guifg=#9DEEF2
hi Ignore               cterm=none ctermbg=none ctermfg=8           gui=none        guifg=bg
hi Constant             cterm=none ctermbg=none ctermfg=12          gui=none        guifg=#96D9F1
hi PreProc              cterm=none ctermbg=none ctermfg=10          gui=none        guifg=#D1FA71
hi Type                 cterm=none ctermbg=none ctermfg=12          gui=none        guifg=#96D9F1
hi Statement            cterm=none ctermbg=none ctermfg=10          gui=none        guifg=#D1FA71
hi Special              cterm=none ctermbg=none ctermfg=6           gui=none        guifg=#d7d7d7
hi String               cterm=none ctermbg=none ctermfg=3           gui=none        guifg=#F6DC69
hi Number               cterm=none ctermbg=none ctermfg=3           gui=none        guifg=#F6DC69
hi Underlined           cterm=none ctermbg=none ctermfg=magenta     gui=underline   guibg=#272727
hi Symbol               cterm=none ctermbg=none ctermfg=9           gui=none        guifg=#FAB1AB
hi Method               cterm=none ctermbg=none ctermfg=15          gui=none        guifg=#F7F7F7
hi Interpolation        cterm=none ctermbg=none ctermfg=6           gui=none        guifg=#2EB5C1

function! GitConflicts()
  :cexpr system('ag "<<<<" --vimgrep') | copen
endfunction

function! Todos()
  :cexpr system('ag "todo" --vimgrep') | copen
endfunction

command! Gconflicts :call GitConflicts()
command! Todos :call Todos()
command! Close :call Close()
command! OpenFolder :call OpenFolder()
command! OpenRoot :call OpenRoot()
command! CloseNetrw :call CloseNetrw()
command! Dotfiles :e ~/dotfiles
command! SyntaxAttr :call SyntaxAttr()
command! Diff :w !diff % -
command! W write|bdelete

nnoremap B ^
onoremap B ^
vnoremap B ^
nnoremap E $
onoremap E $
vnoremap E $

nnoremap V v$h
vnoremap v V

" Navigate vim panes
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-L> <C-W><C-L>
" nnoremap <C-H> <C-W><C-H>

nnoremap s :w<CR>
nnoremap S :wq<CR>

nnoremap q :bd<CR>
nnoremap Q :q<CR>

onoremap iq i"
vnoremap iq i"
onoremap q i"
vnoremap q i"

nnoremap gp :set paste<CR>

nmap \ gcc
vmap \ gc

nnoremap <C-l> <Tab>

nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

nnoremap , ;
nnoremap ; ,

nnoremap Y y$

nnoremap j gj
nnoremap k gk

nnoremap gj J
nnoremap gk kJ

nnoremap g. :Dotfiles<CR>

nnoremap gq :cclose<CR>
map <C-j> :cn<CR>
map <C-k> :cp<CR>

nnoremap - :OpenFolder<CR>
nnoremap _ :OpenRoot<CR>

noremap J 5j
noremap K 5k

nnoremap U <C-R>

nnoremap <leader>p :GitMRUFiles<CR>
nnoremap <leader>F :Ag!
nnoremap <leader>f :BLines!<CR>
