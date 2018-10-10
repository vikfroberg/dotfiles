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
