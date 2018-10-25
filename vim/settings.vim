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
set mouse=a
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

function! s:open_folder(folder)
  if a:folder ==# '.'
    execute 'Ex ' . getcwd()
  else
    execute 'Ex ' . a:folder
  endif
endfunction

function! s:git_folders(...)
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  if v:shell_error
    return s:warn('Not in git repo')
  endif
  let ls_tree = split(system('git ls-tree -rd HEAD'), '\n')
  let ls_tree_clean = map(copy(ls_tree), 'split(v:val, ''\t'')[1]')
  let source = ['.'] + ls_tree_clean
  return fzf#run({
        \'source': source,
        \'sink': function('s:open_folder'),
        \'options': '--no-sort --exact'})
endfunction

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
      \   'right': [ [ 'mode' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
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
