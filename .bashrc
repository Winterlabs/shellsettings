#-- interactive shell inits
PROMPT_COMMAND=__prompt_command

__prompt_command() {
	local curr_exit="$?"
	EX_STR=""
    VENV=""

	[ ${curr_exit} -gt 0 ] && EX_STR="\[\e[0;31m\](${curr_exit})\[\e[0m\]"
    [ -z ${VIRTUAL_ENV} ] || VENV="\n\[\e[1;34m\]$(basename $VIRTUAL_ENV)\[\e[0m\]"

	PS1="\[\e]0;\w\a\]${VENV}\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\[\033[0;37m\]\t ${EX_STR} \[\033[0;0m\]\$ "
	export PS1
}

export HISTSIZE=5000
export HISTFILESIZE=$HISTSIZE
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S %s "
shopt -s histappend

export EDITOR=vim
which $EDITOR 1>/dev/null 2>&1 || export EDITOR=vi

alias gits='git status'
alias gitbranch='git branch -vva'
