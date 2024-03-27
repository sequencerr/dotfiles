#!/bin/bash
BACKUP_DIR=$(dirname $(readlink -f "$0"))

backup () {
local    src="$HOME/$1"
local target="$BACKUP_DIR/dotfiles/$1"

if   [ -d $src ]; then
    local back_dir="$target"
    target=$(dirname "$target")
elif [ -e $src ]; then
    local back_dir=$(dirname "$target")
else
    echo "E: File or directory to backup does not exist: $src"
    return 1
fi
[ -d "$back_dir" ] || mkdir -p "$back_dir"

cp "$src" "$target" -rfvx # --recursive --force --verbose --one-file-system 
}

# nvm ls # <- stupid (no single responsibility), slow
modules_backup_dir="$BACKUP_DIR"/restore/nvm-global-modules
[ -d "$modules_backup_dir" ] || mkdir -p "$modules_backup_dir"
node_modules () {
for dir in $1; do 
    [ ! -d $dir ] && continue
    
    ver=$(basename "$dir")
    [[ $ver != v* ]] && continue

    save_file="$modules_backup_dir/$ver.txt"
    [ -e "$save_file" ] && rm "$save_file"

    declare -A set
    for bin in "$dir"/bin/*; do 
        [ -L $bin ] || continue

        n=$(echo "$dir"/lib/node_modules/name | awk -F'/' '{print NF}')
        pkg=$(echo "$(readlink -f "$bin")" | awk -F'/' "{print \$$n}")
        [ "$pkg" == npm ] && continue

        if [ "${set[$pkg]}" ]; then continue; fi
        set["$pkg"]=1

        echo "$pkg" >> "$save_file"
    done
done
}

echo "$(cat "$HOME"/.bash_history | grep --color=none -v -P  '(([\da-f]+::?){4,5}[\da-f]+|([\d]+\.){3}[\d]+)')" \
    > "$HOME"/.bash_history
# dotfiles
backup .bashrc
backup .bash_history # bad idea (with filtering anyway), on other side it's bad to pass sensitive info to commands (in console). I must to remeber to use space before command to not save it. 
backup .ssh/config
backup .config/xfce4/terminal/terminalrc
backup .config/xfce4/xfconf/xfce-perchannel-xml
backup .config/Code/User/settings.json
backup .config/Code/User/keybindings.json
backup .config/Code/User/snippets

# restore

node_modules ""${NVM_DIR}"/*"
node_modules ""${NVM_DIR}"/versions/node/*"

# code --list-extensions --show-versions > $BACKUP_DIR/.config/Code/User/extensions.txt # slow
[ -d "$BACKUP_DIR"/restore/vscode ] || mkdir -p "$BACKUP_DIR"/restore/vscode
(cat ~/.config/Code/CachedExtensions/user | jq -r '.result[] | (.id + "@" + .version)') \
    > "$BACKUP_DIR"/restore/vscode/extensions.txt
# sqlite3 $HOME/.config/Code/User/globalStorage/state.vscdb \
# "SELECT value FROM ItemTable WHERE key='extensionsIdentifiers/disabled';" \
# | jq -r .[].id 

# https://askubuntu.com/a/492343
[ -d "$BACKUP_DIR"/restore/apt ] || mkdir -p "$BACKUP_DIR"/restore/apt
for l in $(comm -23 \
    <(apt-mark showmanual | sort -u) \
    <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u))
    do echo $l >> "$BACKUP_DIR"/restore/apt/packages.txt
done

[ -d "$BACKUP_DIR"/restore/snap ] || mkdir -p "$BACKUP_DIR"/restore/snap
[ $(command -v snap) ] && (snap list 2>/dev/null > "$BACKUP_DIR"/restore/snap/packages.txt)