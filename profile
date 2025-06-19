export PATH=":$HOME/Code/vikfroberg/dotfiles/bin:$PATH"
export PATH="/usr/local/:$PATH"

export CLICOLOR=1
export EDITOR=nvim
export NODE_ENV="development"
export GIT_MERGE_AUTOEDIT=no
export FZF_DEFAULT_OPTS="--color 16 --reverse"
export BAT_THEME="base16"


# Language
# ----------------------------
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

# Navigation
# -------------
alias -- -='cd -'
alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"

# Listing files
# -------------

# Colored ls
if [ -x /usr/bin/dircolors ]; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
elif [ "$PLATFORM" = Darwin ]; then
  alias ls='ls -G'
fi

alias l="ls -l"
alias ll="ls -l"
alias la="ls -la"

# 
alias c="clear"
alias r="source ~/Code/vikfroberg/dotfiles/profile"

# Vim
# -------------
alias v="vimmer"

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
