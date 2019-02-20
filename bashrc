export PATH='/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:~/dotfiles/bin':"$PATH"
export GIT_MERGE_AUTOEDIT=no
export EDITOR=vim
export CLICOLOR=1
export FZF_DEFAULT_OPTS="--color 16 --reverse"
export NODE_ENV="development"

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8


# Alias
# -------------

# Bash
alias cd="push_cd"
alias dc="pop_cd"
alias ..="cd .."
alias ...="..;.."
alias ....="..;..;.."
alias l="ls -l"
alias ll="ls -l"
alias la="ls -la"
alias c="clear"
alias v="vimmer"
alias r="source ~/.bash_profile"

# Git
alias gs="git status"
alias ga="git add"
alias gaa="git add --all"
alias gap="git add --all --intent-to-add && git add --patch"
alias gd="git diff"
alias gc="git commit -v"
alias gca="git add --all && git commit -v"
alias gl="gh"
alias gll="gh"
alias gp="git push origin \$(git rev-parse --abbrev-ref HEAD)"
alias gpr="git pull --rebase origin \$(git rev-parse --abbrev-ref HEAD)"
alias go="git checkout"
alias gco="alias"
alias gob="git checkout \$(gb)"
alias gof="git checkout \$(gf)"
alias gst="git stash --include-untracked"
alias ge="vim \$(gf)"

# Virtual box
alias vbox="ssh -XY $USER@192.168.56.101"

# Webbhuset
alias whd="/var/www/tools/dev-docker/start"

# Magento
alias magento="sudo -uwww-data php7.0 \$(git rev-parse --show-toplevel)/magento/bin/magento"


# Cd
# -------------

m2() {
  if [ -z "$1" ]
    then
      cd /var/www/m2/$(basename $PWD)
      return
  fi
  cd /var/www/m2/$1
}

elm() {
  if [ -z "$1" ]
    then
      cd /var/www/elm/$(basename $PWD)
      return
  fi
  cd /var/www/elm/$1
}

push_cd() {
  pushd "$1" > /dev/null
}

pop_cd() {
  popd > /dev/null
}


# Vim
# -------------

vimmer() {
  if [ -z "$1" ]
    then
      vim .
      return
  fi
  if [ -z "$2" ]
    then
      vim $1
      return
  fi
  vim +$2 $1
  return
}


# FZF
# -------------

# Grep

gg() {
  if [ -z "$1" ]
    then
      echo "usage: gg QUERY"
      return
  fi
  is_in_git_repo || return
  grep -ir -n "$1" . |
  fzf -d: --preview="preview {1}:{2}" |
  awk -F: '{print $1, $2}'
}

ggI() {
  if [ -z "$1" ]
    then
      echo "usage: gg QUERY"
      return
  fi
  is_in_git_repo || return
  grep -r -n "$1" . |
  fzf -d: --preview="preview {1}:{2}" |
  awk -F: '{print $1, $2}'
}

# Git

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -200' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's/.*\///'
}

gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -200'
}

gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf --ansi --no-sort --reverse --multi \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -200' |
  grep -o "[a-f0-9]\{7,\}"
}

gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}

gsl() {
  is_in_git_repo || return
  git stash list | fzf --reverse -d: --preview 'git show --color=always {1}' |
  cut -d: -f1
}


# History
# https://davidebove.com/blog/2016/04/29/persistent-bash-history-an-experiment/
# -------------

alias h="tail -200 ~/.persistent_history"
alias hf="tac ~/.persistent_history | fzf"

HISTTIMEFORMAT="%d/%m/%y %T "

log_bash_persistent_history()
{
    [[
    $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$
    ]]
    local date_part="${BASH_REMATCH[1]}"
    local command_part="${BASH_REMATCH[2]}"
    if [ "$command_part" != "$PERSISTENT_HISTORY_LAST" ]
    then
        echo "$command_part" >> ~/.persistent_history
        export PERSISTENT_HISTORY_LAST="$command_part"
    fi
}

# Stuff to do on PROMPT_COMMAND
run_on_prompt_command()
{
  log_bash_persistent_history
}

PROMPT_COMMAND="run_on_prompt_command"


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

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
