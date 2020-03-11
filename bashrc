export PATH=":$HOME/dotfiles/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

export CLICOLOR=1

export EDITOR=vim

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

export FZF_DEFAULT_OPTS="--color 16 --reverse"

export NODE_ENV="development"

export GIT_MERGE_AUTOEDIT=no

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"


# Alias
# -------------

# Bash
alias cd="push_cd"
alias dc="pop_cd"
alias -- -='cd -'
alias ..="cd .."
alias ...="..;.."
alias ....="..;..;.."
alias l="ls -l"
alias ll="ls -l"
alias la="ls -la"
alias c="clear"
alias v="vimmer"
alias r="source ~/.bash_profile"
alias ducks="du -cks * | sort -rn | head"

# Git
alias gs="git status"
alias ga="git add"
alias gap="git add --all --intent-to-add && git add --patch"
alias gd="git diff"
alias gc="git commit -v"
alias gca="git add --all && git commit -v"
alias gl="gh"
alias gp="git push origin \$(git rev-parse --abbrev-ref HEAD)"
alias gpr="git pull --rebase origin \$(git rev-parse --abbrev-ref HEAD)"
alias gcb="git checkout \$(gb)"
alias gcf="git checkout \$(gf)"
alias gsu="git stash --include-untracked"

# Virtual box
alias vbox="ssh $USER@virtual-box"

# Webbhuset
alias whd="/var/www/tools/dev-docker/start"
alias magento="sudo -uwww-data php7.0 \$(git rev-parse --show-toplevel)/magento/bin/magento"
alias ivar="cd /var/www/elm/ivar/app"


# Cd
# -------------

push_cd() {
  if [ $1 = "." ]; then
    pushd ~/dotfiles > /dev/null
  else
    pushd "$1" > /dev/null
  fi
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

# fd - cd to selected directory

fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  echo $dir
}


# Git
# -------------

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
  git branch -a --color=always | grep -v '/HEAD\s' |
  fzf --ansi --multi --preview-window right:60% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -200' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's/.*\///'
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
