" Plugins
" -----------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Features
" Plug 'mattn/emmet-vim'
" Plug 'ervandew/supertab'
  " let g:SuperTabDefaultCompletionType = "<C-n>"
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
  let g:fzf_layout = { 'down': '40%' }
  let g:fzf_tags_command = 'ctags -R'
  command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
  command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>,
    \                 <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%', '?')
    \                         : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
    \                 <bang>0)
Plug 'junegunn/vim-slash'
Plug 'junegunn/vim-after-object'
  autocmd VimEnter * call after_object#enable('=', ':', '-', '#', ' ', ',', '|')
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
" - snake_case (crs)
" - MixedCase (crm)
" - camelCase (crc)
" - snake_case (crs)
" - UPPER_CASE (cru)
" - dash-case (cr-)
" - dot.case (cr.)
" - space case (cr<space>)
" - Title Case (crt)

Plug 'tpope/vim-surround'
" Plug 'matze/vim-move'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-fugitive'
Plug 'vikfroberg/vaffle.vim'
  let g:vaffle_force_delete = 1
  let g:vaffle_use_default_mappings = 0
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
  autocmd FileType vaffle call s:customize_vaffle_mappings()
" Plug 'vikfroberg/repl-visual-no-reg-overwrite'
Plug 'dkarter/bullets.vim'
Plug 'vikfroberg/vim-gfm-syntax'
Plug 'ton/vim-bufsurf'

" Syntax
Plug 'jparise/vim-graphql'
Plug 'pangloss/vim-javascript'
Plug 'rescript-lang/vim-rescript'
  " autocmd BufWritePre *.res RescriptFormat
  " function! s:customize_rescript_mappings() abort
  "   nmap <buffer> gd :RescriptJumpToDefinition<cr>
  "   nmap <buffer> gh :RescriptTypeHint<cr>
  " endfunction
  " autocmd FileType rescript call s:customize_rescript_mappings()

" Plug 'mxw/vim-jsx'
"   let g:jsx_ext_required = 0

" Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': ['javascript', 'json'] }

" Plug 'elzr/vim-json'
" Plug 'andys8/vim-elm-syntax'
" Plug 'purescript-contrib/purescript-vim'
" Plug 'vikfroberg/vim-elm-syntax'
" Plug 'neovimhaskell/haskell-vim'
" Plug 'hdima/python-syntax'
" Plug 'leafgarland/typescript-vim'

" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'nkrkv/nvim-treesitter-rescript'

" LSP Support
Plug 'lukas-reineke/lsp-format.nvim'

" Autocompletion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Copilot
Plug 'github/copilot.vim'
call plug#end()

:lua require("vikfroberg.lsp")
":lua require("vikfroberg.treesitter")
:lua require("vikfroberg.cmp")

" Leader
" ----------------------------
noremap <Space> <NOP>
let mapleader = "\<Space>"

imap <silent><script><expr> <C-l> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true


" Settings
" -------------------------------------

set autoindent
set autoread
set backspace=indent,eol,start
set cursorline
set encoding=utf-8
set hidden
set lazyredraw
set visualbell
set clipboard=unnamed
set noswapfile
set nowrap
set scrolloff=7
set nonumber
set showcmd
set noshowmode
set linespace=3
set listchars=nbsp:¬
set guifont=Menlo:h16
set tabstop=2 shiftwidth=2 expandtab
set softtabstop=2
set smartindent
set smarttab
set hlsearch
set incsearch
set ignorecase smartcase
set list " hightlight trailing and nbsb
set splitright

" Fix timeout for esc
set ttimeout
set ttimeoutlen=0
set notimeout

" Semi persistent undo
" if has('persistent_undo')
"   set undodir=/tmp,.
"   set undofile
" endif

let g:loaded_matchparen = 1 " Show matching paren
let g:markdown_fenced_languages = ['elm', 'javascript', 'js=javascript', 'rescript', 'res=rescript']
let g:html_indent_tags = 'li\|p' " More sane html idention
let g:vim_json_syntax_conceal = 1


" Auto commands
" ----------------------------------
augroup vimrc
  autocmd!

  " Don't add comment when using o/O
  autocmd FileType * setlocal formatoptions-=o

  " Unset paste on InsertLeave
  autocmd InsertLeave * silent! set nopaste

  " Create directories on write
  function! s:mkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
      let dir=fnamemodify(a:file, ':h')
      if !isdirectory(dir)
        call mkdir(dir, 'p')
      endif
    endif
  endfunction
  autocmd BufWritePre * :call s:mkNonExDir(expand('<afile>'), +expand('<abuf>'))

  " Strip whitespace
  function! s:preserve(command)
    let _s=@/
    let l = line(".")
    let c = col(".")
    execute a:command
    let @/=_s
    call cursor(l, c)
  endfunction
  command! TrimWhitespace :call s:preserve("%s/\\s\\+$//e")
  autocmd BufWritePre *.elm :TrimWhitespace

  " Show trailing when out of insert mode
  autocmd InsertEnter * set listchars=nbsp:¬
  autocmd InsertLeave * set listchars=nbsp:¬,trail:␣

  " Source vimrc on save
  autocmd BufWritePost .vimrc source %
  autocmd BufWritePost vimrc source %
  autocmd BufWritePost .vim source %

  " Set indention for langs
  autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType elm setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType purescript setlocal ts=2 sts=2 sw=2 expandtab

  " Markdown settings
  function! s:markdown_settings()
    set wrap linebreak nolist
    inoremap <buffer> <Tab> <C-t>
    inoremap <buffer> <S-Tab> <C-d>
  endfunction
  autocmd FileType markdown call s:markdown_settings()

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

" Markdown
hi! link markdownUrl Special
hi! link markdownUrlTitle Special
hi! link markdownLinkText Special

" Javascript
hi! link jsVariableDef Constant
hi! link jsArrowFunction Normal


" Key bindings
" -------------------------------
" Sane ^/$ for swedish keyboard
nnoremap B ^
onoremap B ^
xnoremap B ^
nnoremap E $
onoremap E $
xnoremap E $

" More sane redo
nnoremap U <C-R>

" Make c/d/v/y more consistent
nnoremap V v$h
xnoremap v V
xnoremap y ygv<Esc>
nnoremap Y y$

" Do not yank when c:hanging and x:ing
nnoremap c "_c
xnoremap c "_c
nnoremap cc "_S
nnoremap C "_C
xnoremap C "_C
nnoremap x "_x
xnoremap x "_x
nnoremap X "_X
xnoremap X "_X

" Do not yank when pasting in visual mode
xnoremap p P
xnoremap P p

" Reverse repeat action
" Makes more sense on a swedish keyboard
nnoremap , ;
nnoremap ; ,

" Save and quit hotkeys
nnoremap s :w<CR>
nnoremap S :wq<CR>
nnoremap q :BW<CR>
nnoremap Q :q<CR>
nnoremap gq :bw!<CR>
nnoremap gQ :q!<CR>

" Hotkeys for quotes
onoremap iq i"
xnoremap iq i"
onoremap q i"
xnoremap q i"

" Set paste mode for when copying
nnoremap gp :set paste<CR>

" Vim commentary
nmap \ gcc
xmap \ gc

" Move display lines instead of physical line
nnoremap j gj
nnoremap k gk

" Join hotkeys
nnoremap gj J

" Quick navigation
noremap J 5j
noremap K 5k

" Navigate quickfix
map <C-j> :cn<CR>
map <C-k> :cp<CR>

" Tabs
nnoremap <Tab> >>
nnoremap <S-Tab> <<
xnoremap <Tab> >gv
xnoremap <S-Tab> <gv

" Leaders
nnoremap <leader>p :GitMRUFiles<CR>
nnoremap <leader>b :Buffers!<CR>
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


" FZF <3 MRU
" ------------------------------
command! GitMRUFiles :call s:mru_files()

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
  let files = sort(split(system('fd -c never -tf'), '\n'))
  " let relative_mru = filter(copy(mru), 'index(files, v:val) != -1')
  let current_filename = fnamemodify(expand('%'), ":~:.")
  let relative_mru_without_current = filter(copy(mru), 'v:val !=# current_filename')
  let files_without_mru = filter(copy(files), 'index(mru, v:val) == -1')
  let source = extend(relative_mru_without_current, files_without_mru)
  return fzf#run({ 'source': source, 'sink': 'e', 'options': '--color 16 --no-sort --exact'})
endfunction


" Close buffer and go to netrw root
" -----------------------------------------
function! s:bw_root()
  if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) < 2
    execute "bw"
    execute "e ."
  else
    execute "bw"
  endif
endfunction

command! BW :call s:bw_root()


" HL | Find out syntax group
" -------------------------------------
function! s:hl()
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')
endfunction

command! HL :call s:hl()

" Vaffle
" --------------------------------------
nnoremap - :Vaffle %<CR>
