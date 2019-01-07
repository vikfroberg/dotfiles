export PATH='/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin':"$PATH"
export GIT_MERGE_AUTOEDIT=no
export EDITOR=vim
export CLICOLOR=1
export FZF_DEFAULT_OPTS="--color 16 --reverse"
export NODE_ENV="development"

set -o vi
# set -o emux

# Bash
alias ..="cd .."
alias ...="..;.."
alias ....="..;..;.."
alias l="ls -l"
alias la="ls -la"
alias c="clear"
alias v="vim ."
alias r="source ~/.bash_profile; clear"

# Git
alias gs="git status"
alias ga="git add \$(fgs)"
alias gaa="git add --all"
alias gap="git add --all --intent-to-add && git add --patch"
alias grs="git reset HEAD"
alias grm="git rm \$(fgls)"
alias gd="git diff"
alias gc="git commit"
alias gca="git add --all && git commit"
alias gl="git show \$(fgl)"
alias gll="git show \$(fgll)"
alias gp="git push origin \$(git rev-parse --abbrev-ref HEAD)"
alias gpr="git pull --rebase"
alias gco="git checkout \$(fgs)"
alias gb="git checkout \$(fgb)"
alias gbr="git checkout \$(fgbr)"
alias gbd="git branch -D \$(fgb)"

# Virtual box
alias vbox="ssh -XY $USER@192.168.56.101"

# Webbhuset
alias whd="/var/www/tools/dev-docker/start"

# Helpers
fkill() {
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    kill -${1:-9} $pid
  fi
}

fgl() {
  git log master.. --oneline | fzf --ansi | awk '{print $1}'
}

fgll() {
  git log --oneline -50 | fzf --ansi --preview 'echo {}' | awk '{print $1}'
}

fgls() {
  git ls-files -oc --exclude-standard | sort | fzf --ansi --multi | awk '{print $1}'
}

fgs() {
  git -c color.status=always status --short |
  fzf --multi --ansi --nth 2..,.. | awk '{print $2}'
}

fgb() {
  git branch --color=always | grep -v '/HEAD\s' |
  fzf --multi --ansi --tac | sed 's/^..//' | awk '{print $1}'
}

fgbr() {
  git branch -r --color=always | grep -v '/HEAD\s' |
  fzf --multi --ansi --tac | sed 's/^..//' | awk '{print $1}'
}

danger() {
  read -p "Are you sure? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    return 1
  fi
}

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
    echo "$branch"
  fi
}

get_pwd() {
    if [[ $PWD = $HOME ]]
    then
        echo "~"
    else
        echo $PWD
    fi
}

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

export PS1="\[${MAGENTA}\]\h\[${NOCOLOR}\]:\[${CYAN}\]\$(get_pwd) \[${GRAY}\]\$(git_branch)\$(git_dirty)\[${NOCOLOR}\] \n$ "
