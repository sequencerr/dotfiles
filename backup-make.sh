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
backup $XDG_CONFIG_HOME/flameshot/flameshot.ini
backup $XDG_CONFIG_HOME/procps/toprc
backup $XDG_CONFIG_HOME/pulse/default.pa
backup $XDG_CONFIG_HOME/dconf/user
backup $XDG_CONFIG_HOME/autostart
backup $XDG_CONFIG_HOME/npm/npmrc
backup $XDG_CONFIG_HOME/Thunar
backup $XDG_CONFIG_HOME/xfce4/terminal/terminalrc
backup $XDG_CONFIG_HOME/xfce4/xfconf/xfce-perchannel-xml
backup $XDG_CONFIG_HOME/mimeapps.list
backup $XDG_DATA_HOME/themes

[ -d $BACKUP_DIR/home/.mozilla/firefox/profile ] || mkdir -p $BACKUP_DIR/home/.mozilla/firefox/profile
cp -rfvxL $HOME/.mozilla/firefox/$(grep -Pom1 'Default=\K[^1].+' ~/.mozilla/firefox/profiles.ini)/user.js $BACKUP_DIR/home/.mozilla/firefox/profile

backup /etc/default/console-setup
backup /etc/default/grub
backup /etc/grub.d/40_custom
backup /etc/lightdm/lightdm.conf
backup /etc/systemd/logind.conf
backup /etc/UPower/UPower.conf
backup /etc/apt/sources.list

backup /etc/motd
backup /etc/issue
backup /etc/update-motd.d
