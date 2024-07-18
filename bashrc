export PATH=":$HOME/dotfiles/bin:$PATH"
export PATH="/usr/local/:$PATH"
export PATH="~/Code/Viktor/roc-js/.roc_nightly-macos_x86_64-2024-06-18-41ea2bf/:$PATH"

export CLICOLOR=1
export EDITOR=nvim
export NODE_ENV="development"
export GIT_MERGE_AUTOEDIT=no
export FZF_DEFAULT_OPTS="--color 16 --reverse"
export BAT_THEME="base16"


# Make sure we have en lang
# ----------------------------
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_TYPE=en_US.UTF-8


# Base16 Shell
# --------------

BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"


# Alias
# -------------

# Theme
alias light='base16_github'
alias dark='base16_irblack'

# Colored ls
if [ -x /usr/bin/dircolors ]; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
elif [ "$PLATFORM" = Darwin ]; then
  alias ls='ls -G'
fi

# Bash
alias -- -='cd -'
alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"
alias l="ls -l"
alias ll="ls -l"
alias la="ls -la"
alias c="clear"
alias v="vimmer"
alias r="source ~/.bash_profile"

# Ctags
alias ptags="ag -l | ctags --links=no -L-"

# Git
alias gs="git status"
alias gaf="git add \$(gf)"
alias gap="git add --all --intent-to-add && git add --patch"
alias gd="git diff"
alias gc="git commit -v --no-verify"
alias gca="git add --all && git commit -v --no-verify"
alias gcaa="git add --all && git commit -v --no-verify --amend"
alias gl="gh"
alias gp="git push origin \$(git rev-parse --abbrev-ref HEAD)"
alias gpf="git push origin \$(git rev-parse --abbrev-ref HEAD) --force-with-lease"
alias gpr="git pull --rebase origin \$(git rev-parse --abbrev-ref HEAD)"
alias gcb="git checkout \$(gb)"
alias gcf="git checkout \$(gf)"
alias gst="git stash --include-untracked"
alias grmf="git rm \$(gf)"
alias rmf="rm \$(gf)"
alias grm="git checkout master && gpr && git checkout - && git rebase master"
alias gmm="git checkout master && gpr && git checkout - && git merge master"

# Virtual box
alias vbox="ssh $USER@virtual-box"


# Git rebase/merge helpers
# -----------------------
# Vim
# -------------

vimmer() {
  if [ -z "$1" ]
    then
      nvim .
      return
  fi
  if [ -z "$2" ]
    then
      nvim $1
      return
  fi
  nvim +$2 $1
  return
}

# Git
# -------------

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

gf() {
  is_in_git_repo || return
  git -c color.status=always status . --short |
  fzf -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' |
  fzf --ansi --multi --preview-window right:60% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -200' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's/^remotes\/[^\/]*\///'
}

gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf --ansi --no-sort --reverse --multi \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -200' |
  grep -o "[a-f0-9]\{7,\}"
}

gsl() {
  is_in_git_repo || return
  git stash list | fzf --reverse -d: --preview 'git show --color=always {1}' |
  cut -d: -f1
}

# iTerm shell integration
# -------------

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"


# Linuxbrew
# -------------

test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)


# Auto complete parent dir
# --------------

..cd() {
  cd ..
  cd "$@"
}

_parent_dirs() {
  COMPREPLY=( $(cd ..; find . -mindepth 1 -maxdepth 1 -type d -print | cut -c3- | grep "^${COMP_WORDS[COMP_CWORD]}") )
}

complete -F _parent_dirs -o default -o bashdefault ..cd


# Prompt
# -------------

git_dirty() {
  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    echo '*'
  fi
}

git_branch() {
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    echo "$branch" | awk 'length > 30{$0=substr($0,0,31)"..."}1'
  fi
}

get_pwd() {
  echo $(dirs -c; dirs)
}

if [[ $- == *i* ]]; then
  # Colors
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  MAGENTA="$(tput setaf 5)"
  CYAN="$(tput setaf 6)"
  WHITE="$(tput setaf 7)"
  GRAY="$(tput setaf 8)"
  BOLD="$(tput bold)"
  UNDERLINE="$(tput sgr 0 1)"
  INVERT="$(tput sgr 1 0)"
  NOCOLOR="$(tput sgr0)"

  export PS1="\[${RED}\]\h\[${NOCOLOR}\]:\[${BLUE}\]\$(get_pwd) \[${YELLOW}\]\$(git_branch)\$(git_dirty)\[${NOCOLOR}\] \n$ "
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval "$(starship init bash)"

# pnpm
export PNPM_HOME="/Users/vikfroberg/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
