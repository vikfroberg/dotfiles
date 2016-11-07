export PATH="/usr/local/sbin:$PATH"
export GIT_MERGE_AUTOEDIT=no
export EDITOR=vim
export CLICOLOR=1
export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"
export HOMEBREW_GITHUB_API_TOKEN="8aa8aaad344669540a4b108cfc4c02dbda5c78f3"
export NVM_DIR="$HOME/.nvm"
  . "$(brew --prefix nvm)/nvm.sh"

# Brew
alias bs="brew services"

# Bash
alias t="cat $PWD/TODO.md"
alias tt="vim $PWD/TODO.md"
alias n="cat ~/NOTES.md"
alias nn="vim ~/NOTES.md"
alias l="ls -l"
alias la="ls -la"
alias c="clear"
alias vi="vim ."
alias v="vim ."
alias ..="cd .."
alias ...="..;.."
alias ....="..;..;.."

# Dotfiles
alias r="source ~/.bash_profile; clear"
alias bprofile="vim ~/.bash_profile"
alias gignore="vim ~/.gitignore"
alias gconfig="vim ~/.gitconfig"
alias vrc="vim ~/.vimrc"
alias d="vim ~/Code/dotifiles"

# Projects
alias vundle="cd ~/.vim/bundle"
alias dfiles="cd ~/Code/dotfiles"
alias carvanro="cd ~/Code/carvanro"
alias yogg="cd ~/Code/yogg"

# Carvanro
alias db="psql carvanro_development"
alias shell="python manage.py shell"
alias web="python manage.py runserver"
alias worker="celery -A app.tasks worker --loglevel=info -Q email,es --purge"

# Git
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gca="git commit -a"
alias gl="git log master.. --oneline"
alias gpr="git pull --rebase"
alias gp="git push -u"
alias go="git checkout"

# Ctags
alias gtags="ctags -R --exclude=.git --exclude=node_modules --exclude=dist"

# ESLint
alias lint="./node_modules/.bin/eslint"
alias glint="git diff master --name-status | grep '^\(A\|M\).*\.jsx\?$' | sed 's/^[AM]//g' | xargs ./node_modules/.bin/eslint"

function git() {
    if [[ $1 = "pull" || $1 = "checkout" || $1 = "stash" ]]
    then
        if [[ -d "$(git rev-parse --show-toplevel)/sites/default" ]]
        then
            chmod -R 777 "$(git rev-parse --show-toplevel)/sites/default"
        fi
    fi

    command git "$@"
}

function get_todo_count() {
  COUNT=0
  if [[ -f "$PWD/TODO.md" ]]
  then
    COUNT="$(cat "$PWD/TODO.md" | wc -l | xargs)"
    if [[ $COUNT -gt 0 ]]
    then
      echo "$txtred($COUNT)$txtrst"
    fi
  fi
}

function get_pwd() {
    if [[ $(basename $PWD) = "vikfroberg" ]]
    then
        echo "~"
    else
        echo $(basename $PWD)
    fi
}

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(direnv hook bash)"

if [ -f ~/.git-completion.bash  ]; then
. ~/.git-completion.bash
fi

export PS1="\[$txtgrn\]\$(get_pwd) \[$txtylw\]\$git_branch\[$txtrst\] \$(get_todo_count)\n$ "
