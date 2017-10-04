nnoremap B ^
nnoremap E $
nnoremap ^ <NOP>
nnoremap $ <NOP>

nnoremap V v$h
vnoremap v V

nnoremap gi viio<Esc>
nnoremap gI viioo<Esc>

nnoremap gp `[v`]

nmap \ gcc
vmap \ gc

nnoremap ! :!

nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

nnoremap - 0i             A--------------0f-x~f-x~f-x~f-x~0f:la'AF;r,i'llD==
nnoremap '' viwa'hviwoi'l

nnoremap , ;
nnoremap ; ,

inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

nnoremap Y y$

nnoremap j gj
nnoremap k gk

nnoremap H b
nnoremap L e
noremap J 5j
noremap K 5k

nnoremap U <C-R>

nnoremap <C-J> f<Space>a<Cr><Esc>
nnoremap <C-K> :join<CR>

nnoremap <leader>p :GitMRUFiles<CR>
nnoremap <leader>f :BLines!<CR>
nnoremap <leader>F :Ag!<CR>
noremap <leader><Tab> <C-W><C-W>
