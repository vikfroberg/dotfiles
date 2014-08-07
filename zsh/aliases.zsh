# unix
alias ln='ln -v'
alias mkdir='mkdir -p'
alias ...='../..'
alias ..='cd ..'
alias ...='cd ...'
alias e="$EDITOR"
alias v="$VISUAL"
alias topten="history | commands | sort -rn | head"
alias c="clear"

# git
alias gs="git status"
alias ga="git add"
alias gap="git add -p"
alias gaa="git add --all"
alias gc="git commit -v"
alias gd="git diff"
alias gcam="git commit --amend"

# bundler
alias b="bundle"

# rails
alias migrate="rake db:migrate"
alias remigrate="rake db:migrate && rake db:rollback && rake db:migrate"
alias m="migrate"
alias s="rspec"

