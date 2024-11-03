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
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then . /usr/share/bash-completion/bash_completion;
  elif [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi
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
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_BINARY_HOME=$HOME/.local/bin
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export MAVEN_OPTS=-Dmaven.repo.local="$XDG_CACHE_HOME/maven/repository"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export BUN_INSTALL_BIN="$XDG_BINARY_HOME"
export BUN_INSTALL_CACHE_DIR="$XDG_CACHE_HOME/bun"
export BUN_INSTALL_GLOBAL_DIR="$XDG_DATA_HOME/bun"
export DENO_INSTALL_ROOT="$XDG_BINARY_HOME"
export DENO_DIR="$XDG_CACHE_HOME/deno"
export DENO_REPL_HISTORY="$XDG_DATA_HOME/deno/deno_history.txt"
export DENO_NO_UPDATE_CHECK=1
export NVM_DIR="$XDG_DATA_HOME/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

export DO_NOT_TRACK=1
export NEXT_TELEMETRY_DISABLED=1
export PATH="$XDG_CONFIG_HOME/composer/vendor/bin:$XDG_BINARY_HOME:$PATH"

for cmd in $(ls "$(pwd)/node_modules/.bin" 2> /dev/null); do
    bin="$(pwd)/node_modules/.bin/$cmd"
    alias $cmd="echo -e \"Using local: \\\"$bin\\\" -> \\\"\$(readlink -f $bin)\\\" \n\" && command $(readlink -f $bin)";
done && unset bin cmd

alias rm='echo Consider using \"trash\"'
alias trash='trash -v'
alias trash-list="trash-list | awk '{print NR-1, \$0}' | sort -k2,3 | column -t | sed -E 's/\/home\/[^/]+/~/g'"
alias mkdir="mkdir -pv"
alias tree="tree --dirsfirst -ACI '.git' -I node_modules"
alias ls='LC_ALL=C ls -CA --color=auto --group-directories-first'
alias ll='LC_ALL=C ls -lhA'
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'
alias path='echo -e ${PATH//:/\\n}'
alias grep='grep --color=auto'
alias ipa='ip -f inet -4 -c -p -br a'
alias jcu='sudo journalctl --utc -b -r -u'
alias sc='sudo systemctl'
alias df="df -Th --total | grep -vP 'tmp|sys'"
alias mnts="mount | grep ^/dev | awk '{print \$1\"\\t\"\$3\"\\t\"\$5}' | column -t"
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
psk() { psg "$@" | tee >(tail -n+2 | awk '{print $2}' | xargs -r kill -9) | tee >(tail -n+2 | awk '{print $2}' | xargs -r echo -e "\nKilled PIDs:"); }
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias src='time source ~/.bashrc'

keygen() { ssh-keygen -t ed25519 -C "$(git config user.email)" -P '' -f "$HOME/.ssh/$1" && echo -e "\n~/.ssh/$1.pub:" && cat "$HOME/.ssh/$1.pub"; }

apt() {
    if [[ $1 == 'install' ]]; then
        sudo apt install --yes --no-install-recommends --auto-remove "${@:2}"
    else
        sudo apt "$@"
    fi
}

docker() {
  if [[ $1 == "dive" ]]; then
    if [ -z "$2" ]; then
      if command -v fzf &> /dev/null; then
        IMAGES=$(sudo docker images --format "{{.Repository}}:{{.Tag}} {{.ID}} {{.CreatedSince}} {{.Size}}")
        IMAGE=$(echo "$IMAGES" | fzf --prompt="Select an image (repository:tag): " --height=15 --ansi)
        if [ -n "$IMAGE" ]; then
          IMAGE_ID=$(echo "$IMAGE" | awk '{print $2}')
          sudo docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive "$IMAGE_ID"
        else
          echo "No image selected."
        fi
      else
        echo "Available Docker images:"
        IMAGES=$(sudo docker images --format '{{.Repository}}:{{.Tag}}')
        select IMAGE in $IMAGES; do
          if [ -n "$IMAGE" ]; then
            sudo docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive "$IMAGE"
            break
          else
            echo "Invalid selection. Please try again."
          fi
        done
      fi
    else
      sudo docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive "$2"
    fi
  elif [[ $1 == "monitor" ]]; then
    sudo -E $XDG_BINARY_HOME/lazydocker "${@:2}"
  else
    sudo docker "$@"
  fi
}

if command -v zoxide > /dev/null; then
    cd='z'
    eval "$(zoxide init bash)"
fi
cd() { ${cd:-cd} "$@" && ls && echo && pwd; }
