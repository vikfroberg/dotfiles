" TO LEARN:
" Ctrl + v - start visual block mode
" :vimgrep /pattern/ {file}
" :cn - jump to the next match
" :cp - jump to the previous match
" :copen - open a window containing the list of matches

nnoremap B ^
onoremap B ^
nnoremap E $
onoremap E $

nnoremap V v$h
vnoremap v V

onoremap n :<c-u>normal! f=bviw<cr>
vnoremap n :<c-u>normal! f=bviw<cr>
onoremap N :<c-u>normal! f=wvt;<cr>
vnoremap N :<c-u>normal! f=wvt;<cr>

onoremap p :<c-u>normal! f(vi(<cr>

onoremap b :<c-u>normal! f[vi[<cr>
vnoremap b :<c-u>normal! f[vi[<cr>

onoremap B :<c-u>normal! f{vi{<cr>
vnoremap B :<c-u>normal! f{vi{<cr>

onoremap iq i"
vnoremap iq i"
onoremap q i"
vnoremap q i"

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

nnoremap <C-J> f<Space>a<Cr><Esc>
nnoremap <C-K> :join<CR>

nnoremap <leader>b :Buffers<CR>
nnoremap <leader>p :GitMRUFiles<CR>
nnoremap <leader>f :BLines!<CR>
nnoremap <leader>F :Ag!<CR>
noremap <leader><Tab> <C-W><C-W>
