HISTFILE=~/.zshist
HISTSIZE=100000
SAVEHIST=1000000
setopt appendhistory sharehistory histignoredups histignorespace extendedhistory extendedglob notify promptsubst interactivecomments noflowcontrol autopushd pushdignoredups pushdsilent automenu listpacked cshjunkieloops autocd
unsetopt beep nomatch
bindkey -e
disable -p '#'

zstyle :compinstall filename '/home/lutostag/.zshrc'

autoload -Uz compinit colors zmv
compinit
colors

zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'

export EDITOR=vim
export GPGKEY=1F3EB44A
export DEBFULLNAME="Greg Lutostanski"
export DEBEMAIL="gregory.lutostanski@canonical.com"
export TERMINAL=gnome-terminal
export GOPATH=~/src/go

if [ -z $SETPATH ]
then
    export PATH=$PATH:$GOPATH/bin
    export PYTHONPATH=$(ls -1d ~/work/src/*/*/trunk/ 2>/dev/null | tr '\n' ':')
    export PYTHONDONTWRITEBYTECODE=True
    export SETPATH=1
fi

export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

export AUTOSSH_PORT=0

stty stop undef
stty start undef
ssh-add ~/.ssh/id_rsa 2>/dev/null

touch ~/.z
source ~/.config/z/z.sh 2>/dev/null
source ~/.config/lxc-cmd/lxd-cmd.sh 2>/dev/null
source ~/.config/git_prompt.zsh 2>/dev/null

function mk {
    mkdir $@;
    cd $@;
}

SSH_EXEC=$(which autossh) || SSH_EXEC=$(which ssh)
MAN_EXEC=$(which man)

function man {
    $MAN_EXEC -l $($MAN_EXEC -w $@)
}

function pig {
    args=("$@")
    lexer=$(pygmentize -N "$args")
    if [ "$lexer" == "text" ];
    then
        echo "$args" | grep -q 'diff' && lexer="diff"
    fi
    $args | pygmentize -O bg=dark,style=monokai -f terminal256 -l $lexer -- 2>/dev/null | less -FRX
}

function ssh {
    lxd-ssh
    if [ "$#" == "1" ];
    then
        found=0
        tmux list-panes -aF '#{pane_current_command} #{pane_tty}' | grep ssh | awk '{print $2}' |
        while read x; do lsof -t $x; done |
        while read y; do cat /proc/$y/cmdline | tr "\0" "\n" | grep -qxF "$@" && ls -l /proc/$y/fd/ | grep -o "/dev/pts/[0-9]*"; done | sort -u |
        while read z;
            do tmux select-pane -t $(tmux list-panes -aF '#{pane_tty} #{pane_id}' | grep "$z" | awk '{print $2}') 2>/dev/null &&
            tmux select-window -t $(tmux list-panes -aF '#{pane_tty} #{window_id}' | grep "$z" | awk '{print $2}') &&
            found=1;
        done;
        if [ "$found" == "0" ];
        then
            $SSH_EXEC -t $@ "tmux has-session -t lutostag 2>/dev/null && tmux list-clients -F '#{pane_tty}_#H' | grep -qFx ${TTY}_$(hostname) - 2>/dev/null && NOTMUX=1 zsh 2>/dev/null || tmux new -s lutostag 2>/dev/null || tmux attach -t lutostag 2>/dev/null || zsh 2>/dev/null || bash -l"
        fi
    else
        $SSH_EXEC $@
    fi
}

function ranger-cd {
    tempfile="/tmp/ranger-$(uuidgen)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ];
    then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

function work {
    source ~/.virtualenvs/${1:-"one"}/bin/activate
}

function work-autocomplete {
    reply=( $(ls -1 ~/.virtualenvs) )
}

alias ls='ls -xFX --group-directories-first --color=auto' # -C

function chpwd() {
    start=$'\E[101m'
    finish=$'\E[0m'
    emulate -L zsh
    ls -xw $(($(tput cols) - 1)) --color=always | sed -n '1h; 2H; 3{x; s/^\(.*\)$/\1 '"$start…$finish"'/; p; q}; ${x; p}'
    # print -S " $(echo \# $(pwd))"
}

compctl -K work-autocomplete work

bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
bindkey '^[^M' self-insert-unmeta

function browse-or-vim() {
    if [[ -d $1 ]]
    then
        ranger $@
    else
        nvim $@ 2>/dev/null || vim $@
    fi
}

function chhost() {
    hostname=$1
    sudo sed -i '/127.0.1.1/d' /etc/hosts
    echo "127.0.1.1 $hostname" | sudo tee -a /etc/hosts >/dev/null
    echo "$hostname" | sudo tee /etc/hostname >/dev/null
    sudo hostname "$hostname"
}

alias -g today='$(date +%F)'
alias p='pig '
alias b='bzr'
alias g='git'
alias dirs='dirs -v | sed "s/^/+/"'
alias vi='browse-or-vim'
alias ranger='ranger-cd'
alias zmv='noglob zmv -W'
alias include_tags='ctags -f ~/.cache/ctags/include -R /usr/include'
alias tag='mkdir -p ~/.cache/ctags; ctags -f ~/.cache/ctags/src -R ~/work/src/*/*/trunk'
alias grep='grep --color=auto'
alias cmu='sshfs home:/media/External/Music/ccmixter ~/music/ccmixter 2>/dev/null; cmus'
alias irc='auscult -a 127.0.0.1:1234 2>/dev/null & tmux rename-window irc; ssh home -R 127.0.0.1:1234:127.0.0.1:1234 -t "TERM=screen-256color; tmux -q2u attach -t irc || tmux -2u new-session -s irc irssi"; tmux set-window-option -q automatic-rename "on" >/dev/null'
alias transmission='ssh home -t "bash -ic transmission" || bash -ic transmission'
alias update='sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y'
alias top='htop 2>/dev/null || top'
alias ipy='ipython --no-banner --no-confirm-exit'
alias ipy3='ipython3 --no-banner --no-confirm-exit'
alias usshfs='for host in $(grep "Host " ~/.ssh/config | cut -d " " -f 2); do fusermount -u /tmp/sshfs/$host 2>/dev/null; unlink $host 2>/dev/null; rmdir /tmp/sshfs/$host 2>/dev/null; done'
alias msshfs='usshfs; mkdir -p /tmp/sshfs; for host in $(grep "Host " ~/.ssh/config | cut -d " " -f 2); do mkdir -p /tmp/sshfs/$host; ( ( sshfs $host: /tmp/sshfs/$host 2>/dev/null && ln -s /tmp/sshfs/$host $host ) & ); done'
alias rscp='rsync -avz --partial --progress -e ssh'
alias reconnect='killall -HUP autossh'
alias add-apt-key='sudo apt-key adv --keyserver keyserver.ubuntu.com --recv'


hcolor=$(($(printf '%d' "0x$(hostname | md5sum | sed 's/\(.\{8\}\).*/\1/')") % 256))
ucolor=$(($(printf '%d' "0x$(whoami | md5sum | sed 's/\(.\{8\}\).*/\1/')") % 256))
if [ $(hostname) == "cia" ]; then
    hcolor='4' # blue
elif [ $(hostname) == "fbi" ]; then
    hcolor='2' # green
fi
if [ $(whoami) == "lutostag" ]; then
    ucolor='2' # green
elif [ $(whoami) == "ubuntu" ]; then
    ucolor='1' # red
elif [ $(whoami) == "root" ]; then
    ucolor='3' # yellow
fi
PROMPT_VALUE="%{%F{$ucolor}%B%}%n%{%b$reset_color%}@%F{$hcolor}%{%B%}%M%f%{%b$reset_color%}:%{$fg[yellow]%B%}%~%{%b$reset_color%}"
PROMPT="${PROMPT_VALUE}$ "

[[ $ucolor == $hcolor ]] && ucolor=$((($hcolor + 1) % 256))
[[ $hcolor =~ "^[0-9]+$" ]] && hcolor=colour${hcolor}
[[ $ucolor =~ "^[0-9]+$" ]] && ucolor=colour${ucolor}

cat > ~/.tmux.extra.conf <<EOF
set-option -qg status-bg $hcolor
set -qg status-left "#{?client_prefix,#[bg=$ucolor],#[bg=$hcolor]}#[fg=black][#S]"
EOF

tmux source-file ~/.tmux.conf 2>/dev/null

if [ -n $SSH_CLIENT -a "$NOTMUX" != "1" ]
then
    tmux -2u attach 2>/dev/null || tmux -2u 2>/dev/null && exit
elif [ $TERM == "xterm-256color" -a -z $TMUX ]
then
    TERM=screen-256color
    tmux -2u attach 2>/dev/null || tmux -2u 2>/dev/null && exit;
elif [ $TERM == "linux" -a `pgrep -c startx` -lt 1 ]
then
    startx 2>/dev/null
    exit;
fi
