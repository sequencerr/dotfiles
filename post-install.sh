'export HISTTIMEFORMAT="%F %T "\
export HISTIGNORE="?:??:???:pwd:clear:reset:exit:forget*:history*:cd -:exit:date:* --help"\
alias forget=""' >> ~/.bashrc
source ~/.bashrc
# todo: move to bash profile 

#!/bin/sh
# todo: grub

# https://docs.docker.com/engine/install/debian/#install-using-the-repository
# for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt remove $pkg; done
# Add Docker's official GPG key:
# sudo apt update
# sudo apt install ca-certificates
# sudo install -m 0755 -d /etc/apt/keyrings
sudo wget -q https://download.docker.com/linux/debian/gpg -O /etc/apt/keyrings/docker.asc
# sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo docker run --user $RANDOM:$RANDOM hello-world
# sudo systemctl status docker.service
# sudo systemctl status containerd.service

# https://operavps.com/docs/how-to-install-vs-code-on-ubuntu-using-snap-apt-gui#Installing_Visual_Studio_Code_with_apt
# https://www.xda-developers.com/how-to-install-vs-code-on-ubuntu#How_to_install_VS_Code_with_apt 
# https://phoenixnap.com/kb/install-vscode-ubuntu
# https://medium.com/@GRajeevan/how-to-install-visual-studio-code-on-ubuntu-22-04-bfc87b52cc40
# https://linuxhint.com/install-visual-studio-code-ubuntu22-04/
# sudo apt install software-properties-common apt-transport-https wget
sudo wget -q https://packages.microsoft.com/keys/microsoft.asc -O /etc/apt/keyrings/microsoft.asc
sudo echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft.asc] https://packages.microsoft.com/repos/vscode stable main" | \
  sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
sudo apt update
sudo apt install code

# https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo#how-to-install-for-debianubuntulinux-mint
sudo wget https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
-O /usr/share/keyrings/vscodium-archive-keyring.asc
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.asc ] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update
sudo apt install codium
# sudo apt install codium-insiders -y

# https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa -> Technical details about this PPA -> Signing key
sudo wget -qO - 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xf23c5a6cf475977595c89f51ba6932366a755776' \
-O /usr/share/keyrings/deadsnakes-archive-keyring.asc
echo "deb [ signed-by=/usr/share/keyrings/deadsnakes-archive-keyring.asc ] http://ppa.launchpad.net/deadsnakes/ppa/ubuntu $(lsb_release -cs) main" \
    | sudo tee /etc/apt/sources.list.d/deadsnakes-ppa.list
sudo apt update

# https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#release-files
# https://github.com/yt-dlp/yt-dlp/wiki/Installation#apt
sudo add-apt-repository ppa:tomtomtom/yt-dlp
sudo apt update
sudo apt install yt-dlp

# # https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script
# wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# https://github.com/nvm-sh/nvm?tab=readme-ov-file#manual-install
git clone --depth 1 https://github.com/nvm-sh/nvm.git "$HOME/.nvm"
#cd "$HOME/.nvm"
#git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
echo "export NVM_DIR=\"$HOME/.nvm\"
[ -s \"$HOME/.nvm/nvm.sh\" ] && \. \"$HOME/.nvm/nvm.sh\"" >> ~/.bashrc
source ~/.bashrc
command -v nvm
nvm -v
nvm current
nvm install -b --latest-npm stable
nvm install -b --latest-npm --lts=iron               # 20.x
nvm install -b --latest-npm --lts=hydrogen --default # 18.x
nvm install -b --latest-npm --lts=gallium            # 16.x
nvm use default
nvm current
node -v
npm -v

# command -v corepack npm install -g corepack
# corepack enable yarn
# yarn set version berry
# https://raw.githubusercontent.com/yarnpkg/berry/master/packages/plugin-essentials/sources/commands/set/version.ts
# https://repo.yarnpkg.com/master/packages/yarnpkg-cli/bin/yarn.js
# https://repo.yarnpkg.com/3.3.0/packages/yarnpkg-cli/bin/yarn.js
# curl -fsSL https://api.github.com/repos/yarnpkg/berry/releases/latest | jq .name -r
url=https://raw.githubusercontent.com/yarnpkg/berry/master/packages/yarnpkg-cli/bin/yarn.js
bin_dir=$HOME/.yarn/releases
if [[ ! -d $bin_dir ]]; then mkdir -p "$bin_dir"; fi
curl --fail --location --progress-bar --output "$bin_dir/yarn-berry-latest.cjs" "$url"
ln -s "$bin_dir/yarn-berry-latest.cjs" "$bin_dir/yarn"
chmod +x "$bin_dir/yarn"
echo "export PATH=$bin_dir:\$PATH" >> ~/.bashrc
source ~/.bashrc
command -v yarn
yarn --version

# https://raw.githubusercontent.com/pnpm/get.pnpm.io/main/install.sh
# curl -fsSL https://api.github.com/repos/pnpm/pnpm/releases/latest | jq .name -r
tmp_dir="$(mktemp -d)"; trap 'rm -rf "$tmp_dir"' EXIT INT TERM HUP
url=https://github.com/pnpm/pnpm/releases/latest/download/pnpm-linux-x64
wget -q $url -O "$tmp_dir/pnpm"
chmod +x "$tmp_dir/pnpm"
SHELL=bash "$tmp_dir/pnpm" setup --force || return 1

# # https://raw.githubusercontent.com/oven-sh/bun/main/src/cli/install.sh
# curl -fsSL https://bun.sh/install | bash
tmp_dir="$(mktemp -d)"; trap 'rm -rf "$tmp_dir"' EXIT INT TERM HUP
target=linux-x64
url=https://github.com/oven-sh/bun/releases/latest/download/bun-$target.zip
#curl --fail --location --progress-bar --output "$tmp_dir/bun.zip" "$url"
wget "$url" -O "$tmp_dir/bun.zip"
command -v unzip || sudo apt install unzip
command -v bun > /dev/null || unzip -oqd "$tmp_dir" "$tmp_dir/bun.zip"
bin_dir=$HOME/.bun/bin
if [[ ! -d $bin_dir ]]; then mkdir -p "$bin_dir"; fi
mv "$tmp_dir/bun-$target/bun" "$bin_dir/bun"
rm -r "$tmp_dir/bun-$target" "$tmp_dir/bun.zip"
chmod +x "$bin_dir/bun"
echo "export PATH=$bin_dir:\$PATH" >> ~/.bashrc
source ~/.bashrc
command -v bun
bun -v
SHELL=bash bun completions

find ~/.mozilla -type f -name 'prefs.js' -exec sed -i 's/"accessibility.typeaheadfind.enablesound", true/"accessibility.typeaheadfind.enablesound", false/' {} \;
