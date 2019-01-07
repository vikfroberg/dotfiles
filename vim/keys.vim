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
