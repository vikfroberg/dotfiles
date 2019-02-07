export PATH='/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin':"$PATH"
export GIT_MERGE_AUTOEDIT=no
export EDITOR=vim
export CLICOLOR=1
export FZF_DEFAULT_OPTS="--color 16 --reverse"
export NODE_ENV="development"

# Alias
# -------------

# Bash
alias ..="cd .."
alias ...="..;.."
alias ....="..;..;.."
alias l="ls -l"
alias ll="ls -l"
alias la="ls -la"
alias c="clear"
alias v="vim ."
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
alias gco="git checkout"
alias gst="git stash --include-untracked"

# Virtual box
alias vbox="ssh -XY $USER@192.168.56.101"

# Webbhuset
alias whd="/var/www/tools/dev-docker/start"

# GIT heart FZF
# -------------

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

gg() {
  is_in_git_repo || return
  git grep -n $1 |
  fzf -d: --with-nth 1,2 --ansi --preview 'echo {3..}'
  # cut -d: -f1
  # fzf -d: --with-nth 2,3.. --preview 'bat {1} --color=always' --ansi
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
  sed 's#^remotes/##'
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