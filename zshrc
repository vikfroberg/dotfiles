function aliases {
  echo "Available aliases"
  for alias in ~/.zsh/aliases/*; do
    source $alias
  done
}
aliases

function functions {
  for function in ~/.zsh/functions/*; do
    source $function
  done
}
functions

# enable colored output from ls, etc
export CLICOLOR=1

# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# load rbenv if available
if which rbenv &>/dev/null ; then
  eval "$(rbenv init - --no-rehash)"
fi

# load thoughtbot/dotfiles scripts
export PATH="$HOME/.bin:$PATH"

# mkdir .git/safe in the root of repositories you trust
export PATH=".git/safe/../../bin:$PATH"

# frequently-used directories in zsh
cdpath=($HOME $HOME/Dropbox/Code/rails $HOME/Dropbox/Text $HOME/Dropbox)
