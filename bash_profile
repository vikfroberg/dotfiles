export PATH="/usr/local/sbin:$PATH:/Applications/Genymotion.app/Contents/MacOS/tools"
export GIT_MERGE_AUTOEDIT=no
export EDITOR=vim
export CLICOLOR=1
export HOMEBREW_GITHUB_API_TOKEN="8aa8aaad344669540a4b108cfc4c02dbda5c78f3"
export NVM_DIR="$HOME/.nvm"
  . "$(brew --prefix nvm)/nvm.sh"
export FZF_DEFAULT_OPTS="--color 16 --reverse"
export NODE_ENV="development"

# Brew
# alias bs="brew services list"
alias b1="brew services start \$(fbs)"
alias b0="brew services stop \$(fbs)"
alias br="brew services restart \$(fbs)"

# Bash
alias ..="cd .."
alias ...="..;.."
alias ....="..;..;.."
alias l="ls -l"
alias la="ls -la"
alias c="clear"
alias v="vim ."
alias r="source ~/.bash_profile; clear"
alias d="(cd ~/Code/dotfiles && vim .)"
alias p="cd ~/Code; cd \$(tree -L 2 -idf | ramda -srSR 'drop 1' 'dropLast 2' 'map drop 2' | fzf)"
alias n="cd ~/Code; cd \$(tree -L 2 -idf | ramda -srSR 'drop 1' 'dropLast 2' 'map drop 2' | fzf); vim NOTES.md"

# Carvanro
alias db="psql carvanro_development"
alias shell="python manage.py shell"
alias web="python manage.py runserver"
alias worker="celery -A app.tasks worker --loglevel=info -Q es,email,messages,push,regular_ride_generator,ride_match_reminders -B"

# Git
alias gs="git status"

alias ga="git add \$(fgs)"
alias gaa="git add --all"
alias gap="git add --all --intent-to-add && git add --patch"

alias gr="git reset HEAD \$(fgs)"

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
alias gbd="git branch -D \$(fgb)"

alias grs="danger && git reset HEAD && git checkout . && git clean -d --force"

# ESLint
alias lint="./node_modules/.bin/eslint"
alias glint="git diff master --name-status | grep '^\(A\|M\).*\.jsx\?$' | sed 's/^[AM]//g' | xargs ./node_modules/.bin/eslint"


fkill() {
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    kill -${1:-9} $pid
  fi
}

fgl() {
  git log master.. --oneline | fzf --ansi | ramda -rsRS 'map split " "' 'map head'
}

fgll() {
  git log --oneline -100 | fzf --ansi | ramda -rsRS 'map split " "' 'map head'
}

fbs() {
  brew services list | ramda -rsRS 'drop 1' 'map split " "' 'map head' | fzf
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
    if [[ $(basename $PWD) = "vikfroberg" ]]
    then
        echo "~"
    else
        echo $(basename $PWD)
    fi
}

# eval "$(direnv hook bash)"

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

export PS1="$CYAN\$(get_pwd) $GRAY\$(git_branch)\$(git_dirty)$MAGENTA\n❯ $NOCOLOR"
