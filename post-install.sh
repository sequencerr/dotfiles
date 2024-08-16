#!/bin/sh

sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/debian/gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo docker run --user $RANDOM:$RANDOM hello-world

sudo wget -qO /etc/apt/keyrings/microsoft.asc https://packages.microsoft.com/keys/microsoft.asc
sudo echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft.asc] https://packages.microsoft.com/repos/vscode stable main" \
  | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
sudo apt update && sudo apt install code

sudo wget -qO /usr/share/keyrings/vscodium.asc https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
echo 'deb [signed-by=/usr/share/keyrings/vscodium.asc] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main' \
  | sudo tee /etc/apt/sources.list.d/vscodium.list > /dev/null
sudo apt update && sudo apt install codium

sudo wget -qO /etc/apt/keyrings/dbeaver.asc https://dbeaver.io/debs/dbeaver.gpg.key
echo "deb [signed-by=/etc/apt/keyrings/dbeaver.asc] https://dbeaver.io/debs/dbeaver-ce /" \
  | sudo tee /etc/apt/sources.list.d/dbeaver.list > /dev/null
sudo apt update && sudo apt install dbeaver-ce

[ -d "$HOME/.local/bin" ] || mkdir -p "$HOME/.local/bin"
wget -qO ~/.local/bin/yt https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
chmod a+rx ~/.local/bin/yt

git clone --depth 1 https://github.com/nvm-sh/nvm.git "$HOME/.nvm"
echo 'export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> ~/.bashrc
source ~/.bashrc
nvm install -b --latest-npm stable
nvm install -b --latest-npm --lts=iron               # 20.x
nvm install -b --latest-npm --lts=hydrogen --default # 18.x
nvm install -b --latest-npm --lts=gallium            # 16.x
nvm use default
nvm current && nvm -v && node -v && npm -v

[ -d $HOME/.yarn/releases ] || mkdir -p "$HOME/.yarn/releases"
wget --show-progress -qO "$HOME/.yarn/releases/yarn" https://raw.githubusercontent.com/yarnpkg/berry/master/packages/yarnpkg-cli/bin/yarn.js
chmod +x "$HOME/.yarn/releases/yarn"
echo '[ -d "$HOME/.yarn/releases" ] && export PATH="$HOME/.yarn/releases:$PATH"' >> ~/.bashrc
source ~/.bashrc
yarn --version

nvm exec 18 npm install -g pnpm
echo 'alias pnpm="$(find "$NVM_DIR/versions/node" -maxdepth 1 -name "v18*" -print -quit)/bin/pnpm"' >> ~/.bashrc
source ~/.bashrc
pnpm --version

wget --show-progress -qO- https://github.com/oven-sh/bun/releases/latest/download/bun-linux-x64.zip | busybox unzip -ojqd ~/.local/bin -
chmod +x ~/.local/bin/bun
bun --revision && SHELL=bash bun completions 2> /dev/null

wget --show-progress -qO ~/.local/bin/composer https://getcomposer.org/download/latest-stable/composer.phar
if [ "$(wget -qO- https://getcomposer.org/download/latest-stable/composer.phar.sha256)" \
  != "$(sha256sum ~/.local/bin/composer | awk '{ print $1 }')" ]; then
  echo 'Installer currupt'
  exit 1
fi
chmod +x ~/.local/bin/composer
composer --version

echo '[ -d /snap/bin ] && export PATH="/snap/bin:$PATH"' >> ~/.bashrc
sudo ln -s /var/lib/snapd/desktop/applications /usr/share/applications/snapd

find ~/.mozilla -type f -name 'prefs.js' -exec sed -i 's/"accessibility.typeaheadfind.enablesound", true/"accessibility.typeaheadfind.enablesound", false/' {} \;
find ~/.mozilla -type f -name 'prefs.js' -exec sed -i 's/"extensions.screenshots.disabled", false/"extensions.screenshots.disabled", true/' {} \;
find ~/.mozilla -type f -name 'prefs.js' -exec sed -i 's/"ui.key.menuAccessKeyFocuses", true/"ui.key.menuAccessKeyFocuses", false/' {} \;
