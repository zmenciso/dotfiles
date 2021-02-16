# ~/.bashrc: executed by bash(1) for non-login shells.

# vim: set sts=4 sw=4 ts=8 ft=sh

# Locale
export LC_LANG=en_US.UTF-8
#export LC_TIME=ja_JP.UTF-8

export PATH=~/.local/bin:$PATH
#export PATH=~/pkgsrc/bin:$PATH

# Do not load if not interactive
case $- in
    *i*) ;;
      *) return;;
esac

export PS1="\[\e[0;34m\]\u\[\e[0;39m\]@\[\e[1;37m\]\h \e[0;30m\] \[\e[0;32m\]\w \n\e[1;35m\]\$(parse_git_branch)\[\e[1;37m\]>\[\e[0;39m\] "

# Retrieve git branch for bash prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1 /'
}

# yldme file upload
yldme() {
    while [ $# -gt 0 ]; do
        echo $(curl -s --form file="@$1" https://yld.me/paste?raw=1)
        shift
    done
}
export -f yldme

# yldme link shortening
yldme-link() {
    while [ $# -gt 0 ]; do
        echo $(curl -s -X POST -d "$1" https://yld.me/url)
        shift
    done
}
export -f yldme-link

HISTCONTROL=ignoreboth

# Terminal bell
if [ ! -z "$DISPLAY" ]; then
    xset b off
fi

# Append to history
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Check window size after commands
shopt -s checkwinsize

# Fancy prompt
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias cp='cp -iv'
alias rm='rm -i'
alias df='df -h'
alias mv='mv -iv'
alias source='. $@'
alias sudo='sudo '

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Programmable Completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
