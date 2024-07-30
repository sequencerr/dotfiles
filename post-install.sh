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
echo 'deb [ signed-by=/usr/share/keyrings/vscodium.asc ] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main' \
  | sudo tee /etc/apt/sources.list.d/vscodium.list > /dev/null
sudo apt update && sudo apt install codium

[ -d "$HOME/.local/bin" ] || mkdir -p "$HOME/.local/bin"
wget -qO ~/.local/bin/yt https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp 
chmod a+rx ~/.local/bin/yt

git clone --depth 1 https://github.com/nvm-sh/nvm.git "$HOME/.nvm"
echo 'export NVM_DIR="$HOME/.nvm" \
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> ~/.bashrc
source ~/.bashrc
nvm install -b --latest-npm stable
nvm install -b --latest-npm --lts=iron               # 20.x
nvm install -b --latest-npm --lts=hydrogen --default # 18.x
nvm install -b --latest-npm --lts=gallium            # 16.x
nvm use default
nvm current && nvm -v && node -v && npm -v

bin_dir=$HOME/.yarn/releases
[ -d $bin_dir ] || mkdir -p "$bin_dir"
wget -qO "$bin_dir/yarn-berry-latest.cjs" https://raw.githubusercontent.com/yarnpkg/berry/master/packages/yarnpkg-cli/bin/yarn.js
ln -s "$bin_dir/yarn-berry-latest.cjs" "$bin_dir/yarn"
chmod +x "$bin_dir/yarn"
echo "export PATH=$bin_dir:\$PATH" >> ~/.bashrc
source ~/.bashrc
yarn --version

tmp_dir="$(mktemp -d)"; trap "rm -rf \"$tmp_dir\"" EXIT INT TERM HUP
wget -qO "$tmp_dir/pnpm" https://github.com/pnpm/pnpm/releases/latest/download/pnpm-linux-x64
chmod +x "$tmp_dir/pnpm"
SHELL=bash "$tmp_dir/pnpm" setup --force || return 1

tmp_dir="$(mktemp -d)"; trap 'rm -rf "$tmp_dir"' EXIT INT TERM HUP
target=linux-x64
url=https://github.com/oven-sh/bun/releases/latest/download/bun-$target.zip
wget "$url" -O "$tmp_dir/bun.zip"
command -v unzip || sudo apt install unzip
command -v bun > /dev/null || unzip -oqd "$tmp_dir" "$tmp_dir/bun.zip"
bin_dir=$HOME/.bun/bin
if [[ ! -d $bin_dir ]]; then mkdir -p "$bin_dir"; fi
mv "$tmp_dir/bun-$target/bun" "$bin_dir/bun"
rm -r "$tmp_dir/bun-$target" "$tmp_dir/bun.zip"
chmod +x "$bin_dir/bun"
echo '[ -d "$HOME/.bun/bin" ] && export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
bun -v
SHELL=bash bun completions

find ~/.mozilla -type f -name 'prefs.js' -exec sed -i 's/"accessibility.typeaheadfind.enablesound", true/"accessibility.typeaheadfind.enablesound", false/' {} \;
