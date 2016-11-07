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

  " Strip whitespace
  autocmd BufWritePre * :call Preserve("%s/\\s\\+$//e")

  " Python
  autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab

  " Nunjucks
  autocmd BufRead,BufNewFile *.nunjs setfiletype html

  " ESLint
  autocmd BufRead,BufNewFile *.eslintrc setfiletype json

  " Babel
  autocmd BufRead,BufNewFile *.babelrc setfiletype json

augroup END
