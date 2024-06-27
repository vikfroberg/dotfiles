" Plugins
" -----------------------------
" Tab completion
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = '<C-n>'

" Search
Plug 'junegunn/vim-slash'

" Text transform
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

Plug 'APZelos/blamer.nvim'
let g:blamer_delay = 0
nnoremap gb :BlamerToggle<CR>

" LSP Support
Plug 'lukas-reineke/lsp-format.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'

call plug#end()

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

  " Show trailing when out of insert mode
  autocmd InsertEnter * set listchars=nbsp:¬
  autocmd InsertLeave * set listchars=nbsp:¬,trail:␣

  " Set lang for file types
  autocmd BufRead,BufNewFile *.eslintrc setfiletype json
  autocmd BufRead,BufNewFile *.babelrc setfiletype json
  autocmd BufRead,BufNewFile bashrc setfiletype sh
  autocmd BufRead,BufNewFile bash_profile setfiletype sh
augroup END


" Appearance
" ---------------------------------

if filereadable(expand('~/.vimrc_background'))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Markdown
hi! link markdownUrl Special
hi! link markdownUrlTitle Special
hi! link markdownLinkText Special

" Javascript
hi! link jsVariableDef Constant
hi! link jsArrowFunction Normal


" Key bindings
" -------------------------------
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

" Set paste mode for when copying
nnoremap gp :set paste<CR>

" Leaders
nnoremap <leader>p :GitMRUFiles<CR>
nnoremap <leader>b :Buffers!<CR>
nnoremap <leader>f :BLines!<CR>
nnoremap <leader>F :Ag!<CR>
nnoremap <leader>n *
nnoremap <leader>N :Ag! <C-R><C-W><CR>

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
    let filename = fnamemodify(a:filename, ':~:.')
    call filter(g:fzf_mru_files, 'v:val !=# filename')
    call add(g:fzf_mru_files, filename)
  endif
endfunction

function! s:delete_mru_files(filename)
  let filename = fnamemodify(a:filename, ':~:.')
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
  let current_filename = fnamemodify(expand('%'), ':~:.')
  let relative_mru_without_current = filter(copy(mru), 'v:val !=# current_filename')
  let files_without_mru = filter(copy(files), 'index(mru, v:val) == -1')
  let source = extend(relative_mru_without_current, files_without_mru)
  return fzf#run({ 'source': source, 'sink': 'e', 'options': '--color 16 --no-sort --exact'})
endfunction


" Close buffer and go to netrw root
" -----------------------------------------
function! s:bw_root()
  if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) < 2
    execute 'bw'
    execute 'e .'
  else
    execute 'bw'
  endif
endfunction

command! BW :call s:bw_root()

" Dotfiles
" --------------------------------------
command! Dotfiles :FZF! ~/dotfiles
