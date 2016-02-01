export PATH="/usr/local/sbin:$PATH"
export GIT_MERGE_AUTOEDIT=no

export CLICOLOR=1
# export LSCOLORS=GxFxCxDxBxegedabagaced

export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"

alias km-vci="cd ~/Code/www/vci"
alias km-dev="mkdir -p /Volumes/dev; mount 192.168.120.9:/export/dev /Volumes/dev > /dev/null 2>&1"
alias km-stage="ssh dev@192.168.10.4"

alias services="brew services"
alias bs="services"

alias www-start="bs start mysql55; bs start php54; bs start httpd22; bs start dnsmasq"
alias www-restart="bs restart mysql55; bs restart php54; bs restart httpd22; bs restart dnsmasq"
alias www-stop="bs stop mysql55; bs stop php54; bs stop httpd22; bs stop dnsmasq"

alias sub='open -a "/Applications/Sublime Text.app"'
alias e="sub"

alias c="clear"
alias r="source ~/.bash_profile; clear"

alias dotfiles="cd ~/Code/unix/dotfiles"

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

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

export PS1="\[$txtgrn\]\w \[$txtylw\]\$git_branch\[$txtrst\]\\n$ "
