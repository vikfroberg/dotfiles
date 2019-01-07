set nocompatible

scriptencoding utf-8
set encoding=utf-8
filetype plugin indent on
syntax enable
set background=dark

noremap <Space> <NOP>
let mapleader = "\<Space>"

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
set noshowmatch
set splitbelow
set nosplitright
" set splitright
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

let g:netrw_banner = 0

let g:html_indent_tags = 'li\|p'
let g:loaded_matchparen = 1
let g:ackprg = 'ag --vimgrep --smart-case'
let g:multi_cursor_exit_from_insert_mode = 0
let g:vim_json_syntax_conceal = 0
let g:jsx_ext_required = 0


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

function! s:git_files(...)
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  if v:shell_error
    return s:warn('Not in git repo')
  endif
  let mru = reverse(copy(g:fzf_mru_files))
  let files = sort(split(system('git ls-files -oc --exclude-standard')))
  let deleted_files = split(system('git ls-files -d'))
  let files_without_deleted = filter(copy(files), 'index(deleted_files, v:val) == -1')
  let relative_mru = filter(copy(mru), 'index(files_without_deleted, v:val) != -1')
  let filename = fnamemodify(expand('%'), ":~:.")
  let relative_mru_without_current = filter(copy(relative_mru), 'v:val !=# filename')
  let files_without_mru = filter(copy(files_without_deleted), 'index(relative_mru, v:val) == -1')
  let source = extend(relative_mru_without_current, files_without_mru)
  return fzf#run({
        \'source': source,
        \'sink': 'e',
        \'options': '--color 16 --no-sort --exact'})
endfunction

command! GitMRUFiles :call s:git_files()


" Lightline

let g:lightline = {
      \ 'colorscheme': 'custom',
      \ 'active': {
      \   'left': [ [ 'filename' ] ],
      \   'right': [ [ 'branch' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'branch': 'FugitiveStatusline',
      \ }
      \ }

function! LightlineFilename()
  return expand('%')
endfunction

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [ [8, 0] ]
let s:p.normal.middle = s:p.normal.left
let s:p.normal.right = s:p.normal.left

let s:p.insert.left = [ [0, 2] ]
let s:p.insert.middle = s:p.insert.left
let s:p.insert.right = s:p.insert.left

let s:p.visual.left = [ [0, 7] ]
let s:p.visual.middle = s:p.visual.left
let s:p.visual.right = s:p.visual.left

let s:p.replace.left = [ [0, 1] ]
let s:p.replace.middle = s:p.replace.left
let s:p.replace.right = s:p.replace.left

let s:p.normal.error = [ [0, 1] ]
let s:p.normal.warning = [ [0, 3] ]

let g:lightline#colorscheme#custom#palette = lightline#colorscheme#fill(s:p)

" Elm
let g:elm_format_autosave = 0

" Pretttier
" single quotes over double quotes
let g:prettier#config#single_quote = 'false'

" print spaces between brackets
let g:prettier#config#bracket_spacing = 'true'

" put > on the last line instead of new line
let g:prettier#config#jsx_bracket_same_line = 'false'

" none|es5|all
let g:prettier#config#trailing_comma = 'all'

" Autoformat
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.babelrc Prettier


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

augroup vimrc
  autocmd!
  " Do netrw mappings
  autocmd filetype netrw call NetrwMapping()

  " https://github.com/tpope/vim-vinegar/issues/13#issuecomment-47133890
  autocmd FileType netrw setl bufhidden=delete

  " Create directories on write
  autocmd BufWritePre * :call MkNonExDir(expand('<afile>'), +expand('<abuf>'))

  " Don't add comment when using o/O
  autocmd FileType * setlocal formatoptions-=o

  " Strip whitespace
  autocmd BufWritePre * :call Preserve("%s/\\s\\+$//e")

  autocmd BufWritePost .vimrc source %
  autocmd BufWritePost vimrc source %
  autocmd BufWritePost *.vim source %

  autocmd FileType netrw setlocal nocursorline
  autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType elm setlocal ts=4 sts=4 sw=4 expandtab

  autocmd BufRead,BufNewFile *.nunjs setfiletype html
  autocmd BufRead,BufNewFile *.eslintrc setfiletype json
  autocmd BufRead,BufNewFile *.babelrc setfiletype json
augroup END


" Use colorbox for colorscheme
" https://www.colorbox.io/

highlight CursorLine cterm=NONE ctermbg=0 ctermfg=NONE
highlight Visual ctermfg=NONE ctermbg=8
highlight Type ctermfg=2
highlight Comment ctermfg=7 ctermbg=NONE
highlight PreProc ctermfg=2
highlight Special ctermfg=11
highlight Todo ctermfg=7 ctermbg=NONE

" highlight Statement ctermfg=1
" highlight Noise ctermfg=NONE ctermbg=NONE
" highlight Normal ctermfg=white ctermbg=NONE

" highlight Number ctermfg=white
" highlight Identifier ctermfg=white

" highlight jsStorageClass ctermfg=8
" highlight jsVariableDef ctermfg=6
" highlight jsOperator ctermfg=2
" highlight jsObjectBraces ctermfg=8
" highlight jsImport ctermfg=8
" highlight jsModuleBraces ctermfg=8
" highlight jsModuleKeyword ctermfg=white
" highlight jsModuleComma ctermfg=8
" highlight jsFrom ctermfg=8
" highlight jsString ctermfg=3
" highlight jsFuncParens ctermfg=8
" highlight jsFuncArgCommas ctermfg=8
" highlight jsArrowFunction ctermfg=2
" highlight jsBrackets ctermfg=8
" highlight jsBracket ctermfg=NONE
" highlight jsNoise ctermfg=8
" highlight jsParens ctermfg=8
" highlight jsExport ctermfg=8
" highlight jsDestructuringBraces ctermfg=8
" highlight jsObjectProp ctermfg=NONE
" highlight jsFuncArgs ctermfg=NONE
" highlight jsReturn ctermfg=2
" highlight jsConditional ctermfg=2
" highlight jsException ctermfg=2
" highlight jsIfElseBraces ctermfg=8
" highlight jsSpreadOperator ctermfg=3
" highlight jsFuncBraces ctermfg=8
" highlight jsBooleanTrue ctermfg=3
" highlight jsBooleanFalse ctermfg=3
" highlight jsRestOperator ctermfg=3
" highlight jsExportDefault ctermfg=8
" highlight jsObjectSeparator ctermfg=8
" highlight jsFunction ctermfg=8
" highlight jsFuncName ctermfg=4
" highlight jsRegexpCharClass ctermfg=3
" highlight jsRegexpString ctermfg=2
" highlight jsNumber ctermfg=3

" highlight pythonStatement ctermfg=8
" highlight pythonDot ctermfg=8
" highlight pythonImport ctermfg=8
" highlight pythonInclude ctermfg=8
" highlight pythonFunction ctermfg=4

command! SourceVim :source $MYVIMRC
command! Dotfiles :FZF! ~/dotfiles
command! SyntaxAttr :call SyntaxAttr()
command! Diff :w !diff % -
command! Changes :w !diff % -
command! TestFile !py.test %

" TO LEARN:
" Ctrl + v - start visual block mode
" :vimgrep /pattern/ {file}
" :cn - jump to the next match
" :cp - jump to the previous match
" :copen - open a window containing the list of matches
" bind sS to something
" bind mM to something

" nnoremap :: :
" nnoremap : <NOP>
" nnoremap :q <NOP>
" nnoremap :b <NOP>
" nnoremap :wq <NOP>

" nnoremap <C-Y> "+y
" vnoremap <C-Y> "+y
" nnoremap <C-P> "+gP
" vnoremap <C-P> "+gP

nnoremap gs :!git status<CR>
nnoremap ga :w<CR>:!git add %<CR><CR>
nnoremap gd :!git diff %<CR>
nnoremap gD :!git diff<CR>

" nnoremap g gg

nnoremap B ^
onoremap B ^
vnoremap B ^
nnoremap E $
onoremap E $
vnoremap E $

nnoremap V v$h
vnoremap v V

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap s :w<CR>
nnoremap S :w<CR>

" nnoremap m :e %:h<CR>

" nnoremap q <NOP>
" nnoremap Q <NOP>
" nnoremap qq :bd<CR>
" nnoremap QQ :q<CR>
nnoremap q :bd<CR>
nnoremap Q :q<CR>

" onoremap n :<c-u>normal! f=bviw<cr>
" vnoremap n :<c-u>normal! f=bviw<cr>
" onoremap N :<c-u>normal! f=wvt;<cr>
" vnoremap N :<c-u>normal! f=wvt;<cr>

" onoremap p :<c-u>normal! f(vi(<cr>

" onoremap b :<c-u>normal! f[vi[<cr>
" vnoremap b :<c-u>normal! f[vi[<cr>

" onoremap B :<c-u>normal! f{vi{<cr>
" vnoremap B :<c-u>normal! f{vi{<cr>

onoremap iq i"
vnoremap iq i"
onoremap q i"
vnoremap q i"

" onoremap iQ i'
" vnoremap iQ i'
" onoremap Q i'
" vnoremap Q i'

" nnoremap gi viio<Esc>
" nnoremap gI viioo<Esc>

nnoremap gp `[v`]

nmap \ gcc
vmap \ gc

nnoremap ! :!

nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

nnoremap , ;
nnoremap ; ,

nnoremap Y y$

nnoremap j gj
nnoremap k gk

noremap J 5j
noremap K 5k

nnoremap U <C-R>

" nnoremap <C-J> f<Space>a<Cr><Esc>
" nnoremap m :join<CR>

nnoremap <leader>b :Buffers!<CR>
nnoremap <leader>p :GitMRUFiles<CR>
nnoremap <leader>f :BLines!<CR>
nnoremap <leader>F :Ag!<CR>
noremap <leader><Tab> <C-W><C-W>
