case $- in
    *i*) ;;
      *) return;;
esac
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\w\a\]$PS1"
    ;;
*)
    ;;
esac
[ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ] && debian_chroot=$(cat /etc/debian_chroot)
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\w\$ '
fi
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

[ -f ~/.bash_aliases ] && . ~/.bash_aliases
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

shopt -s checkwinsize
shopt -s globstar
shopt -s histappend

export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=100000
export HISTTIMEFORMAT="%F %T "
export HISTIGNORE="?:??:???:pwd:clear:reset:exit:forget*:history*:cd -:exit:date:* --help*"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export BUN_INSTALL_BIN="$HOME/.local/bin"
export BUN_INSTALL_CACHE_DIR="$XDG_CACHE_HOME/bun"
export BUN_INSTALL_GLOBAL_DIR="$XDG_DATA_HOME/bun"
export DO_NOT_TRACK=1
export NEXT_TELEMETRY_DISABLED=1
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -d "$XDG_CONFIG_HOME/composer/vendor/bin" ] && export PATH="$XDG_CONFIG_HOME/composer/vendor/bin:$PATH"
[ -d /snap/bin ] && export PATH="/snap/bin:$PATH"
[ -d "$(pwd)/node_modules/.bin" ] && \
    for cmd in $(ls "$(pwd)/node_modules/.bin"); do
        alias $cmd="echo -e \"Using local: \\\"$(pwd)/node_modules/.bin/$cmd\\\" -> \\\"\$(readlink -f $(pwd)/node_modules/.bin/$cmd)\\\" \n\" && command $(readlink -f $(pwd)/node_modules/.bin/$cmd)";
    done

alias forget=""
alias rm='echo Consider using \"trash\"'
alias trash='trash -v'
alias trash-list="trash-list | awk '{print NR-1, \$0}' | sort -k2,3 | column -t | sed -E 's/\/home\/[^/]+/~/g'"
alias ls='LC_ALL=C ls -CA --color=auto --group-directories-first'
alias ll='LC_ALL=C ls -lhA'
alias tree="tree --dirsfirst -ACI '.git' -I node_modules"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias src='time source ~/.bashrc'
if command -v zoxide > /dev/null; then
    alias cd='z'
    eval "$(zoxide init bash)"
fi
