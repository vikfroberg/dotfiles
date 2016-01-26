export PATH=~"/bin:/usr/local/bin:/usr/local/mysql/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH=/Applications/MAMP/Library/bin/:$PATH
export GIT_MERGE_AUTOEDIT=no

export CLICOLOR=1
# export LSCOLORS=GxFxCxDxBxegedabagaced

export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"

alias km-vci="cd ~/Code/www/vci"
alias km-dev="mkdir -p /Volumes/dev; mount 192.168.120.9:/export/dev /Volumes/dev > /dev/null 2>&1"
alias km-stage="ssh dev@192.168.10.4"

alias sub='open -a "/Applications/Sublime Text.app"'
alias e="sub"

alias c="clear"

alias ebp="sub ~/.bash_profile"
alias rbp="source ~/.bash_profile"

alias ..="cd .."
alias ...="..;.."
alias ....="..;..;.."

alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gl="git stash; git pull; git stash pop"
alias gp="git push"
alias gcp="git cherry-pick"

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

export PS1="\[$txtgrn\]\w \[$txtylw\]\$git_branch\[$txtrst\]\\n$ "












