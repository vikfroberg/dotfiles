command! SourceVim :source $MYVIMRC
command! Dotfiles :FZF! ~/dotfiles
command! SyntaxAttr :call SyntaxAttr()
command! Diff :w !diff % -
command! Changes :w !diff % -
command! TestFile !py.test %
