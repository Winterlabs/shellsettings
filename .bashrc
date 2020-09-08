#-- interactive shell inits
export HISTSIZE=5000
export HISTFILESIZE=$HISTSIZE
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S %s "
shopt -s histappend

export EDITOR=vim
which $EDITOR 1>/dev/null 2>&1 || export EDITOR=vi

alias gits='git status'
alias gitbranch='git branch -vva'
