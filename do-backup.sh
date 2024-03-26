#!/bin/sh
BACKUP_DIR=$(dirname $(readlink -f "$0"))/dotfiles

backup () {
    local    src=$HOME/$1
    local target=$BACKUP_DIR/$1

    if   [ -d $src ] ; then
        local back_dir=$target
        target=$(dirname $target)
    elif [ -e $src ] ; then
        local back_dir=$(dirname $target)
    else
        echo "E: File or directory to backup does not exist: $src"
        exit 1
    fi
    [ -d $back_dir ] || mkdir -p "$back_dir"

    cp $src $target -rfvx # --recursive --force --verbose --one-file-system 
}

backup .ssh/config
backup .config/Code/User/settings.json
backup .config/Code/User/snippets