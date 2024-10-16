#!/bin/sh
set -eu

sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/debian/gpg &
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo wget -qO /etc/apt/keyrings/microsoft.asc https://packages.microsoft.com/keys/microsoft.asc &
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft.asc] https://packages.microsoft.com/repos/vscode stable main" \
  | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

sudo wget -qO /etc/apt/keyrings/vscodium.asc https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg &
echo 'deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/vscodium.asc] https://download.vscodium.com/debs vscodium main' \
  | sudo tee /etc/apt/sources.list.d/vscodium.list > /dev/null

sudo wget -qO /etc/apt/keyrings/ngrok.asc https://ngrok-agent.s3.amazonaws.com/ngrok.asc &
echo "deb [signed-by=/etc/apt/keyrings/ngrok.asc] https://ngrok-agent.s3.amazonaws.com buster main" \
  | sudo tee /etc/apt/sources.list.d/ngrok.list > /dev/null

sudo wget -qO /etc/apt/keyrings/dbeaver.asc https://dbeaver.io/debs/dbeaver.gpg.key &
echo "deb [signed-by=/etc/apt/keyrings/dbeaver.asc] https://dbeaver.io/debs/dbeaver-ce /" \
  | sudo tee /etc/apt/sources.list.d/dbeaver.list > /dev/null

sudo wget -qO /etc/apt/keyrings/google.asc https://dl.google.com/linux/linux_signing_key.pub &
echo "deb [signed-by=/etc/apt/keyrings/google.asc] http://dl.google.com/linux/chrome/deb stable main" \
  | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null

sudo wget -qO /etc/apt/keyrings/waterfox.asc https://download.opensuse.org/repositories/home:hawkeye116477:waterfox/Debian_12/Release.key &
echo 'deb [signed-by=/etc/apt/keyrings/waterfox.asc] http://download.opensuse.org/repositories/home:/hawkeye116477:/waterfox/Debian_12/ /' \
  | sudo tee /etc/apt/sources.list.d/home:hawkeye116477:waterfox.list > /dev/null

sudo wget -qO /etc/apt/keyrings/hardware_razer.asc https://download.opensuse.org/repositories/hardware:razer/Debian_12/Release.key &
echo 'deb [signed-by=/etc/apt/keyrings/hardware_razer.asc] http://download.opensuse.org/repositories/hardware:/razer/Debian_12/ /' \
  | sudo tee /etc/apt/sources.list.d/hardware:razer.list > /dev/null

sudo wget -qO /etc/apt/keyrings/corretto.asc https://apt.corretto.aws/corretto.key &
echo "deb [signed-by=/etc/apt/keyrings/corretto.asc] https://apt.corretto.aws stable main" \
  | sudo tee /etc/apt/sources.list.d/corretto.list > /dev/null

sudo wget -qO /etc/apt/keyrings/githubcli.gpg https://cli.github.com/packages/githubcli-archive-keyring.gpg &
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli.gpg] https://cli.github.com/packages stable main" \
  | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

sudo wget -qO /etc/apt/sources.list https://raw.githubusercontent.com/sequencerr/dotfiles/main/etc/apt/sources.list &

wait

sudo apt update
sudo apt upgrade --yes --no-install-recommends
sudo apt install --yes --no-install-recommends \
    nvidia-driver nvidia-smi firmware-misc-nonfree linux-headers-$(uname -r) \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    code \
    codium \
    ngrok \
    dbeaver-ce \
    google-chrome-stable \
    waterfox-kde \
    razergenie \
    gh \
    git

sudo dpkg-reconfigure nvidia-kernel-dkms

nvidia-smi
sudo docker run --user $RANDOM:$RANDOM hello-world
code --version
codium --version
ngrok --version
dbeaver-ce --version
google-chrome-stable --version
waterfox --version
razergenie --version
gh --version

git clone --depth=1 https://github.com/sequencerr/dotfiles ~/dotfiles || git -C ~/dotfiles pull
cp -rfv ~/dotfiles/home/.config/autostart ~/.config
cp -rfv ~/dotfiles/home/.config/Code ~/.config
cp -rfv ~/dotfiles/home/.config/dconf ~/.config
cp -rfv ~/dotfiles/home/.config/lazydocker ~/.config
cp -rfv ~/dotfiles/home/.config/npm ~/.config
cp -rfv ~/dotfiles/home/.config/procps ~/.config
cp -rfv ~/dotfiles/home/.config/pulse/default.pa ~/.config/pulse/default.pa
cp -rfv ~/dotfiles/home/.config/synapse ~/.config
cp -rfv ~/dotfiles/home/.config/Thunar ~/.config
cp -rfv ~/dotfiles/home/.config/xfce4 ~/.config
cp -rfv ~/dotfiles/home/.gnupg ~
cp -rfv ~/dotfiles/home/.local/share/themes ~/.local/share
cp -rfv ~/dotfiles/home/.mozilla/firefox/profile/user.js ~/.mozilla/firefox/$(grep -Pom1 'Default=\K[^1].+' ~/.mozilla/firefox/profiles.ini)
cp -rfv ~/dotfiles/home/.vscode ~
cp -rfv ~/dotfiles/home/.bashrc ~/.bashrc
cp -rfv ~/dotfiles/home/.gitconfig ~/.gitconfig

sudo cp -rfv ~/dotfiles/etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp -rfv ~/dotfiles/etc/systemd/logind.conf /etc/systemd/logind.conf
sudo cp -rfv ~/dotfiles/etc/UPower/UPower.conf /etc/UPower/UPower.conf
sudo cp -rfv ~/dotfiles/etc/default/console-setup /etc/default/console-setup
sudo update-initramfs -u
sudo cp -rfv ~/dotfiles/etc/grub.d/40_custom /etc/grub.d/40_custom
sudo cp -rfv ~/dotfiles/etc/default/grub /etc/default/grub
sudo update-grub

[ -d "$HOME/.local/bin" ] || mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

git clone --depth 1 https://github.com/sequencerr/XMousePasteBlock.git ~/XMousePasteBlock || :
(cd ~/XMousePasteBlock
sudo docker build --progress=plain -t xmousepasteblock --target export --output type=local,dest=. .
sudo mv -fv ./xmousepasteblock /usr/bin)
/usr/bin/rm -rf ~/XMousePasteBlock
sudo apt install libev-dev

glab_release=$(wget -qO- https://gitlab.com/api/v4/projects/gitlab-org%2Fcli/releases | grep -Po 'tag_name":\s*"v?\K[^"]+' | head -n1)
if ! command -v gl > /dev/null || ! gl --version 2> /dev/null | grep -q "$glab_release"; then
    wget --show-progress -qO- "https://gitlab.com/gitlab-org/cli/-/releases/v$glab_release/downloads/glab_${glab_release}_linux_amd64.tar.gz" | tar -xzf - -C ~/.local/bin --strip-components=1 --transform s/glab/gl/
fi
unset glab_release
gl --version

zoxide_release=$(wget -qO- https://api.github.com/repos/ajeetdsouza/zoxide/releases/latest | grep -Po '^\s\s"name":\s"\K[^"]+')
if ! command -v zoxide > /dev/null || ! zoxide --version 2> /dev/null | grep -q "$zoxide_release"; then
    wget --show-progress -qO- "https://github.com/ajeetdsouza/zoxide/releases/latest/download/zoxide-$zoxide_release-x86_64-unknown-linux-musl.tar.gz" | tar xzf - -C ~/.local/bin zoxide
    chmod +x ~/.local/bin/zoxide
fi
unset zoxide_release
zoxide --version

if ! command -v yt > /dev/null || ! yt --version 2> /dev/null | grep -q "$(wget -qO- https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest | grep -Po 'tag_name":\s*"\K[^"]+')"; then
    wget --show-progress -qO ~/.local/bin/yt https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
    chmod +x ~/.local/bin/yt
fi
yt --version

git clone --depth 1 https://github.com/nvm-sh/nvm.git ~/.local/share/nvm || git -C ~/.local/share/nvm pull
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NVM_DIR="$HOME/.local/share/nvm" && source "$NVM_DIR/nvm.sh"
nvm install -b --latest-npm stable
nvm install -b --latest-npm --lts=iron               # 20.x
nvm install -b --latest-npm --lts=hydrogen --default # 18.x
nvm install -b --latest-npm --lts=gallium            # 16.x
nvm use default
nvm current && nvm -v && node -v && npm -v

yarn_release=$(wget -qO- https://api.github.com/repos/yarnpkg/berry/releases/latest | grep -Po 'tag_name":\s*"\K[^"]+')
if ! command -v yarn > /dev/null || ! echo $yarn_release | grep -q "$(yarn --version)"; then
    [ -d "$HOME/.yarn/releases" ] || mkdir -p ~/.yarn/releases
    wget --show-progress -qO ~/.yarn/releases/yarn "https://raw.githubusercontent.com/yarnpkg/berry/refs/tags/$yarn_release/packages/yarnpkg-cli/bin/yarn.js"
    chmod +x ~/.yarn/releases/yarn
    ln -sfv ~/.yarn/releases/yarn ~/.local/bin/yarn
fi
unset yarn_release
yarn --version

nvm exec 18 npm install -g pnpm
ln -sfv "$(find "$NVM_DIR/versions/node" -maxdepth 1 -name "v18*" -print -quit)/bin/pnpm" ~/.local/bin/pnpm
pnpm --version

if ! command -v bun > /dev/null || ! bun --version | grep -q "$(wget -qO- https://api.github.com/repos/oven-sh/bun/releases/latest | grep -Po '^\s*"tag_name":\s"[^v]+v\K[^"]+')"; then
    tmp_dir="$(mktemp -d)"; trap "/usr/bin/rm -rf \"$tmp_dir\"" EXIT INT TERM HUP
    wget --show-progress -qO $tmp_dir/bun.zip https://github.com/oven-sh/bun/releases/latest/download/bun-linux-x64.zip
    busybox unzip -ojqd ~/.local/bin $tmp_dir/bun.zip
    /usr/bin/rm -r $tmp_dir
    unset tmp_dir
    chmod +x ~/.local/bin/bun
fi
bun --revision && SHELL=bash bun completions 2> /dev/null || true

export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
sudo apt install --yes --no-install-recommends \
    openjdk-17-jdk java-21-amazon-corretto-jdk
sudo update-java-alternatives --set java-21-amazon-corretto
echo ${JAVA_HOME:-}
jshell -q <<< 'System.out.println("\n\n" + System.getProperty("java.version"));'

export MAVEN_OPTS=-Dmaven.repo.local="$XDG_CACHE_HOME/maven/repository"
maven_release=$(wget -qO- https://api.github.com/repos/apache/maven/releases/latest | grep -Po '"name":\s*"(maven-)?\K[^"]+')
if ! command -v mvn > /dev/null || ! mvn --version | head -1 | grep -q "$maven_release"; then
    [ -d "$HOME/.local/share/maven" ] && /usr/bin/rm -rfv ~/.local/share/maven
    mkdir -pv ~/.local/share/maven
    wget --show-progress -qO- "https://dlcdn.apache.org/maven/maven-$(echo $maven_release | cut -c1)/$maven_release/binaries/apache-maven-$maven_release-bin.tar.gz" | tar xzf - -C ~/.local/share/maven --strip-components=1
    ln -sfv ~/.local/share/maven/bin/mvn ~/.local/bin/mvn
fi
unset maven_release
mvn --version

export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
gradle_release=$(wget -qO- https://api.github.com/repos/gradle/gradle/releases/latest | grep -Po '"name":\s*"\K[^"]+')
if ! command -v gradle > /dev/null || ! gradle --version | awk 'NR==3' | grep -q "$gradle_release"; then
    wget --show-progress -qO- "https://services.gradle.org/distributions/gradle-$gradle_release-bin.zip" | busybox unzip -oqd ~/.local/share -
    mv ~/.local/share/gradle* ~/.local/share/gradle
    chmod +x ~/.local/share/gradle/bin/gradle
    ln -sfv ~/.local/share/gradle/bin/gradle ~/.local/bin/gradle
fi
unset gradle_release
gradle --version

composer_release=$(wget -qO- https://api.github.com/repos/composer/composer/releases/latest | grep -Pom1 'name":\s*"\K[^"]+')
if ! command -v composer > /dev/null || ! composer --version 2> /dev/null | awk '{ print $3 }' | grep -q "$composer_release"; then
    sudo apt install --yes --no-install-recommends \
        php php-curl php-dom php-xml
    wget --show-progress -qO ~/.local/bin/composer "https://getcomposer.org/download/$composer_release/composer.phar"
    chmod +x ~/.local/bin/composer
fi
composer --version 2> /dev/null

# echo '[ -d /snap/bin ] && export PATH="/snap/bin:$PATH"' >> ~/.bashrc
sudo ln -sfv /var/lib/snapd/desktop/applications /usr/share/applications/snapd

[ -d "$HOME/.local/share/fonts" ] || mkdir -p "$HOME/.local/share/fonts"
if ! fc-list | grep -q CascadiaCode; then
    wget --show-progress -qO- $(wget -qO- https://api.github.com/repos/microsoft/cascadia-code/releases/latest | grep -Po '^\s*"browser_download_url":\s*"\K[^"]+') | busybox unzip -oqd ~/.local/share/fonts/CascadiaCode -
    /usr/bin/rm -rv ~/.local/share/fonts/CascadiaCode/otf ~/.local/share/fonts/CascadiaCode/**/static ~/.local/share/fonts/CascadiaCode/**/*PL* ~/.local/share/fonts/CascadiaCode/**/*NF*
fi
fc-cache -v

echo -e '\nExecute: "xfce4-session-logout -r"'
