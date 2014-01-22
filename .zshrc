# Lines configured by zsh-newuser-install
HISTFILE=~/.zshist
HISTSIZE=10000
SAVEHIST=100000
setopt appendhistory sharehistory histignoredups extendedglob notify
unsetopt beep nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/lutostag/.zshrc'

autoload -Uz compinit colors
compinit
colors
# End of lines added by compinstall
export TERMINAL=evilvte
export GOPATH=~/src/go
export PATH=$PATH:$GOPATH/bin
export EDITOR=vim
export PYTHONPATH=$PYTHONPATH:~/src/python

PROMPT="%{$fg[cyan]%B%}%n%{%b$reset_color%}@%{$fg[magenta]%B%}%M%{%b$reset_color%}:%{$fg[yellow]%B%}%~%{%b$reset_color%}$ "

source ~/packages/z/z.sh

alias work='source ~/.virtualenv/bin/activate'
alias vi='vim'
alias ls='ls --group-directories-first -X --color=auto'
alias zathura='zathura --fork'
alias transmission='transmission-remote-cli -c !!:!!@localhost:9091'
alias include_tags='ctags -f ~/.cache/ctags/include -R /usr/include'
alias tag='ctags -f ~/.cache/ctags/src -R ~/src'

if [ $TERM == "xterm" -a -z $TMUX ]
then
    tmux -2u attach 2>/dev/null || tmux -2u 2>/dev/null;
    exit;
fi
if [ $TERM == "linux" -a `pgrep startx | wc -l` -lt 1 ]
then
    startx 2>/dev/null
    exit;
fi
