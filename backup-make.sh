#!/bin/bash
BACKUP_DIR=$(dirname $(readlink -f "$0"))

backup () {
local    src="$1"
local target=$(echo "$BACKUP_DIR$(echo $1 | sed 's/^\/home\/[^/]*/\/home/')")

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

cp "$src" "$target" -rfvx
}

backup $HOME/.bashrc
backup $HOME/.bash_history
backup $HOME/.gitconfig
backup $HOME/.ssh/config
backup $HOME/.gnupg/gpg.conf
backup $HOME/.gnupg/gpg-agent.conf
backup $HOME/.gnupg/gpg-wrapper-passphrase.sh
backup $HOME/.themes
backup $HOME/.config/.bunfig.toml
backup $HOME/.config/procps/toprc
backup $HOME/.config/xfce4/terminal/terminalrc
backup $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
backup $HOME/.config/Code/User/settings.json
backup $HOME/.config/Code/User/keybindings.json
backup $HOME/.config/Code/User/snippets
backup $HOME/.vscode/argv.json

# https://stackoverflow.com/a/53887437
backup /etc/udev/rules.d/51-android.rules
backup /etc/fstab
backup /etc/default/grub
backup /etc/grub.d/40_custom
backup /etc/lightdm/lightdm.conf
backup /etc/pulse/default.pa

backup /etc/motd
backup /etc/issue
backup /etc/update-motd.d

modules_backup_dir="$BACKUP_DIR"/restore/nvm-global-modules
[ -d "$modules_backup_dir" ] && rm "$modules_backup_dir"/* || mkdir -p "$modules_backup_dir"
node_modules () {
for dir in $1; do
    declare -A set
    ver=$(basename "$dir")

    [ ! -d $dir ] && continue
    [[ $ver != v* ]] && continue

    for bin in "$dir"/bin/*; do
        [ -L $bin ] || continue

        n=$(echo "$dir"/lib/node_modules/name | awk -F'/' '{print NF}')
        pkg=$(echo "$(readlink -f "$bin")" | awk -F'/' "{print \$$n}")
        [ "$pkg" == npm ] && continue

        [ "${set[$pkg]}" ] && continue
        set["$pkg"]=1

        echo "$pkg" >> "$modules_backup_dir/$ver.txt"
    done
done
}
node_modules ""${NVM_DIR}"/*"
node_modules ""${NVM_DIR}"/versions/node/*"

if [ -d ~/.config/Code ] && command -v jq; then
    [ -d "$BACKUP_DIR"/restore/vscode ] || mkdir -p "$BACKUP_DIR"/restore/vscode
    (cat ~/.config/Code/CachedExtensions/user | jq -r '.result[] | (.id + "@" + .version)') \
        > "$BACKUP_DIR"/restore/vscode/extensions.txt
    sqlite3 $HOME/.config/Code/User/globalStorage/state.vscdb \
    "SELECT value FROM ItemTable WHERE key='extensionsIdentifiers/disabled';" \
    | jq -r .[].id
fi

[ -d "$BACKUP_DIR"/restore/apt ] || mkdir -p "$BACKUP_DIR"/restore/apt
echo -e '\n' >> "$BACKUP_DIR"/restore/apt/packages.txt
sys_pkgs=$(sudo grep -oP "Unpacking \K[^: ]+" /var/log/installer/syslog | sort -u)
for l in $(comm -12 \
    <(echo $(comm -23 \
        <(cat /var/log/apt/history.log | grep -E '^Commandline: apt.+install' | sed -E 's/^Commandline: apt.+install| --?\w+(-\w+)?//g' | sort -u | xargs) \
        <(echo $sys_pkgs)) | tr ' ' '\n' | sort) \
    <(apt-mark showmanual | sort -u | tr ' ' '\n' | sort))
    do echo $l >> "$BACKUP_DIR"/restore/apt/packages.txt
done
echo "$(cat "$BACKUP_DIR"/restore/apt/packages.txt | sort -u | tr ' ' '\n')" > "$BACKUP_DIR"/restore/apt/packages.txt

[ -d "$BACKUP_DIR"/restore/snap ] || mkdir -p "$BACKUP_DIR"/restore/snap
[ $(command -v snap) ] && (snap list 2>/dev/null > "$BACKUP_DIR"/restore/snap/packages.txt)
echo "$(cat "$BACKUP_DIR"/restore/apt/packages.txt | sort -u | tr ' ' '\n')" > "$BACKUP_DIR"/restore/apt/packages.txt
