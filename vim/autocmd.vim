function! Preserve(command)
  let _s=@/
  let l = line(".")
  let c = col(".")
  execute a:command
  let @/=_s
  call cursor(l, c)
endfunction

augroup vimrc
  autocmd!
  " Don't add comment when using o/O
  autocmd FileType * setlocal formatoptions-=o

  " Strip whitespace
  autocmd BufWritePre * :call Preserve("%s/\\s\\+$//e")

  autocmd BufWritePost .vimrc source %
  autocmd BufWritePost vimrc source %
  autocmd BufWritePost *.vim source %

  autocmd FileType netrw setlocal nocursorline
  autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab

  autocmd BufRead,BufNewFile *.nunjs setfiletype html
  autocmd BufRead,BufNewFile *.eslintrc setfiletype json
  autocmd BufRead,BufNewFile *.babelrc setfiletype json
augroup END
