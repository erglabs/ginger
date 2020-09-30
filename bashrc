#!/bin/bash
case $- in *i*) ;; *) return;; esac #GCA#
GINGER_HOME=/home/esavier #GCA#
source /home/esavier/.ginger/init #GCA#
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
TZ='Europe/Warsaw'; export TZ
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

PATH="${PATH}:/home/esavier/.depottols:/home/esavier/.bin"


################################################################################
# The following must be set in the terminal where you start the goma client:
 
# Set this if you want the local webui to listen on 0.0.0.0:8088 instead of 127.0.0.1:8088
#export GOMA_COMPILER_PROXY_LISTEN_ADDR=""
 
# Set GOMA_PROXY_PORT and GOMA_PROXY_HOST if you would like to use a local cache
# before forwarding requests to the backend:
#export GOMA_PROXY_PORT=9090
#export GOMA_PROXY_HOST=gomaproxy.desk.lkpg.corp.vewd.com # For Linköping.
#export GOMA_PROXY_HOST=gomaproxy.desk.wro.corp.vewd.com  # For Wrocław.
#export GOMA_PROXY_HOST=azrael.desk.gbg.corp.vewd.com     # For Gothenburg.
 
# You can check which proxy or server you're currently using by looking at the
# socket_pool setting visible in the goma client web ui:
# http://localhost:8088/#network-stats
 
################################################################################
# The following should be set in the terminal where you make the build:
 
# Don't choose to build some jobs locally (it seems to slow the build):
export GOMA_USE_LOCAL=false
 
# Error out if jobs fail remotely, instead of falling back to building (slowly) locally:
export GOMA_FALLBACK=false
 
# Used by GN.  Alternatively, set the goma_dir GN arg:
export GOMA_DIR=/opt/goma-client
 
# If you want to disable output cache lookups:
#export GOMA_STORE_ONLY=true

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

function to () {
  if test "$2"; then
    cd "$(apparix --try-current-first -favour rOl "$1" "$2" || echo .)"
  elif test "$1"; then
    if test "$1" == '-'; then
      cd -
    else
      cd "$(apparix --try-current-first -favour rOl "$1" || echo .)"
    fi
  else
    cd $HOME
  fi
}
function bm () {
  if test "$2"; then
    apparix --add-mark "$1" "$2";
  elif test "$1"; then
    apparix --add-mark "$1";
  else
    apparix --add-mark;
  fi
}
function portal () {
  if test "$1"; then
    apparix --add-portal "$1";
  else
    apparix --add-portal;
  fi
}
# function to generate list of completions from .apparixrc
function _apparix_aliases ()
{ cur=$2
  dir=$3
  COMPREPLY=()
  nullglobsa=$(shopt -p nullglob)
  shopt -s nullglob
  if let $(($COMP_CWORD == 1)); then
    # now cur=<apparix mark> (completing on this) and dir='to'
    # Below will not complete on subdirectories. swap if so desired.
    # COMPREPLY=( $( cat $HOME/.apparix{rc,expand} | grep "j,.*$cur.*," | cut -f2 -d, ) )
    COMPREPLY=( $( (cat $HOME/.apparix{rc,expand} | grep "\<j," | cut -f2 -d, ; ls -1p | grep '/$' | tr -d /) | grep "\<$cur.*" ) )
  else
    # now dir=<apparix mark> and cur=<subdirectory-of-mark> (completing on this)
    dir=`apparix --try-current-first -favour rOl $dir 2>/dev/null` || return 0
    eval_compreply="COMPREPLY=( $(
      cd "$dir"
      \ls -d $cur* | while read r
      do
        [[ -d "$r" ]] &&
        [[ $r == *$cur* ]] &&
          echo \"${r// /\\ }\"
      done
    ) )"
  eval $eval_compreply
  fi
  $nullglobsa
  return 0
}
# command to register the above to expand when the 'to' command's args are
# being expanded
complete -F _apparix_aliases to

# The outcommented alias does not supplant cd, the other one does.
# alias to    'cd `(apparix -favour rOl \!* || echo -n .)`'
alias to='(test "x-" =  "x\!*") && cd - || (test "x" !=  "x\!*") && cd `(apparix --try-current-first -favour rOl \!* || echo -n .)` || cd'
alias bm='apparix --add-mark \!*'
alias portal='apparix --add-portal \!*'
TZ='Europe/Warsaw'; export TZ

source /home/esavier/.cargo/env
source /home/esavier/.timer/timer.gig
alias ls=exa
alias cp=xcp

PATH="${PATH}:/home/esavier/.prepos/kitty/kitty"

_devshortprompt
