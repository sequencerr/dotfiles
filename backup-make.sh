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

cp "$src" "$target" -rfvxL
}

backup $HOME/.bashrc
backup $HOME/.bash_history
backup $HOME/.gitconfig
backup $HOME/.ssh/config
backup $HOME/.gnupg/gpg.conf
backup $HOME/.gnupg/gpg-agent.conf
backup $HOME/.gnupg/gpg-wrapper-passphrase.sh
backup $HOME/.when/preferences
backup $HOME/.vscode/argv.json
backup $XDG_CONFIG_HOME/Code/User/settings.json
backup $XDG_CONFIG_HOME/Code/User/keybindings.json
backup $XDG_CONFIG_HOME/Code/User/snippets
backup $XDG_CONFIG_HOME/synapse/config.json
backup $XDG_CONFIG_HOME/lazydocker/config.yml
backup $XDG_CONFIG_HOME/procps/toprc
backup $XDG_CONFIG_HOME/dconf/user
backup $XDG_CONFIG_HOME/autostart
backup $XDG_CONFIG_HOME/npm/npmrc
backup $XDG_CONFIG_HOME/Thunar/uca.xml
backup $XDG_CONFIG_HOME/xfce4/terminal/terminalrc
backup $XDG_CONFIG_HOME/xfce4/xfconf/xfce-perchannel-xml
backup $XDG_DATA_HOME/themes

[ -d $BACKUP_DIR/home/.mozilla/firefox/profile ] || mkdir -p $BACKUP_DIR/home/.mozilla/firefox/profile
cp -rfvxL $HOME/.mozilla/firefox/$(grep -Pom1 'Default=\K[^1].+' ~/.mozilla/firefox/profiles.ini)/user.js $BACKUP_DIR/home/.mozilla/firefox/profile

backup /etc/fstab
backup /etc/default/grub
backup /etc/grub.d/40_custom
backup /etc/lightdm/lightdm.conf
backup /etc/pulse/default.pa
backup /etc/systemd/logind.conf
backup /etc/UPower/UPower.conf
backup /etc/apt/sources.list

backup /etc/motd
backup /etc/issue
backup /etc/update-motd.d

modules_backup_dir="$BACKUP_DIR"/restore/nvm-global-modules
[ -d "$modules_backup_dir" ] || mkdir -p "$modules_backup_dir"
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
        [ "$pkg" == npm ] || [ "$pkg" == corepack ] && continue

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

ls ~/.local/share/fonts > "$BACKUP_DIR"/restore/fonts
