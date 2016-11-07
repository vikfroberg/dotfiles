nnoremap <leader>t :TestNearest<CR>
nnoremap <leader>T :TestFile<CR>

" nnoremap <leader>p :History<CR>
nnoremap <leader>p :call FZFGitFiles()<CR>
command! -buffer BTags
  \ call fzf#vim#buffer_tags(<q-args>, [
    \ printf('ctags -f - --sort=no --python-kinds=-xiv --excmd=number --language-force=%s %s', &filetype, expand('%:S'))], {})
nnoremap <leader>r :BTags<CR>
nnoremap <leader>R :Tags<CR>
nnoremap <leader>f :BLines<CR>
nnoremap <leader>F :Ag<CR>

" nnoremap <leader>n <C-N>
" nnoremap <leader>p <C-P>

nnoremap <leader>s :update<CR>
nnoremap <leader>w :bd<CR>
nnoremap <leader>Q :qa<CR>

nnoremap <leader>ev :vsp ~/.vimrc<CR>
nnoremap <leader>en :vsp ~/NOTES.md<CR>

noremap <leader><Tab> <C-W><C-W>
