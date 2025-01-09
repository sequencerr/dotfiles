#!/bin/sh
set -eu

finish() { echo && read -p 'Do you want to reboot now? [Y/^C]: '; xfce4-session-logout -r; }

if ! groups | grep -q sudo; then
    su -c "sudo usermod -aG sudo $USER"
    newgrp sudo <<< 'IS_SUDOED=1 bash <(wget -qO- https://raw.githubusercontent.com/sequencerr/dotfiles/main/post-install.sh)'
    finish
    exit
fi

sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/debian/gpg &
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo wget -qO /etc/apt/keyrings/microsoft.asc https://packages.microsoft.com/keys/microsoft.asc &
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft.asc] https://packages.microsoft.com/repos/code stable main" \
  | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

sudo wget -qO /etc/apt/keyrings/vscodium.asc https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg &
echo 'deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/vscodium.asc] https://download.vscodium.com/debs vscodium main' \
  | sudo tee /etc/apt/sources.list.d/vscodium.list > /dev/null

sudo wget -qO /etc/apt/keyrings/ngrok.asc https://ngrok-agent.s3.amazonaws.com/ngrok.asc &
echo "deb [signed-by=/etc/apt/keyrings/ngrok.asc] https://ngrok-agent.s3.amazonaws.com buster main" \
  | sudo tee /etc/apt/sources.list.d/ngrok.list > /dev/null

# https://pkg.cloudflare.com/index.html#debian-bookworm
sudo wget -qO /etc/apt/keyrings/cloudflare.asc https://pkg.cloudflare.com/cloudflare-main.gpg
echo 'deb [signed-by=/etc/apt/keyrings/cloudflare.gpg] https://pkg.cloudflare.com/cloudflared bookworm main' \
  | sudo tee /etc/apt/sources.list.d/cloudflared.list > /dev/null

sudo wget -qO /etc/apt/keyrings/dbeaver.asc https://dbeaver.io/debs/dbeaver.gpg.key &
echo "deb [signed-by=/etc/apt/keyrings/dbeaver.asc] https://dbeaver.io/debs/dbeaver-ce /" \
  | sudo tee /etc/apt/sources.list.d/dbeaver.list > /dev/null

sudo wget -qO /etc/apt/keyrings/google.asc https://dl.google.com/linux/linux_signing_key.pub &
echo "deb [signed-by=/etc/apt/keyrings/google.asc] http://dl.google.com/linux/chrome/deb stable main" \
  | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null

sudo wget -qO /etc/apt/keyrings/waterfox.asc https://download.opensuse.org/repositories/home:hawkeye116477:waterfox/Debian_12/Release.key &
echo 'deb [signed-by=/etc/apt/keyrings/waterfox.asc] http://download.opensuse.org/repositories/home:/hawkeye116477:/waterfox/Debian_12/ /' \
  | sudo tee /etc/apt/sources.list.d/home:hawkeye116477:waterfox.list > /dev/null

sudo wget -qO /etc/apt/keyrings/mozilla.asc https://packages.mozilla.org/apt/repo-signing-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/mozilla.asc] https://packages.mozilla.org/apt mozilla main" \
    | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null

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

echo "deb http://deb.debian.org/debian bookworm-backports main" \
  | sudo tee /etc/apt/sources.list.d/bookworm-backports.list > /dev/null

wait

sudo apt-get update
sudo apt-get upgrade --yes --no-install-recommends
sudo apt-get install --yes --no-install-recommends \
    linux-image-amd64/bookworm-backports linux-headers-amd64/bookworm-backports \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    virt-manager gir1.2-spiceclientgtk-3.0 qemu-system libvirt-clients libvirt-daemon-system ovmf \
    code \
    codium \
    ngrok \
    cloudflared \
    dbeaver-ce \
    google-chrome-stable \
    waterfox-kde \
    razergenie \
    gh \
    git \
    stow

code --version &
codium --version &
ngrok --version &
dbeaver-ce --version &
google-chrome-stable --version &
waterfox --version &
razergenie --version &
gh --version &
wait
sudo docker run --user $RANDOM:$RANDOM hello-world

git clone --depth=1 https://github.com/sequencerr/dotfiles ~/dotfiles || git -C ~/dotfiles pull
git -C ~/dotfiles remote set-url --push origin git@github.com:sequencerr/dotfiles.git

[ "${XDG_BINARY_HOME:-}" ] || source ~/dotfiles/home/.bashrc
[ -d "$XDG_BINARY_HOME"  ] || mkdir -p "$XDG_BINARY_HOME"
[ -d "$XDG_DATA_HOME/bash-completion/completions" ] || mkdir -p "$XDG_DATA_HOME/bash-completion/completions"
[ -d "$XDG_DATA_HOME/fonts" ] || mkdir -p "$XDG_DATA_HOME/fonts"

if ! fc-list | grep -q CascadiaCode; then
    wget --show-progress -qO- $(wget -qO- https://api.github.com/repos/microsoft/cascadia-code/releases/latest | grep -Po '^\s*"browser_download_url":\s*"\K[^"]+') | busybox unzip -oqd $XDG_DATA_HOME/fonts/CascadiaCode -
    \rm -rv $XDG_DATA_HOME/fonts/CascadiaCode/otf $XDG_DATA_HOME/fonts/CascadiaCode/**/static $XDG_DATA_HOME/fonts/CascadiaCode/**/*PL* $XDG_DATA_HOME/fonts/CascadiaCode/**/*NF*
fi
fc-cache -v

stow -t ~ -d ~/dotfiles --adopt home -vv |& grep -v theme
# todo: fix "Unable to store terminal preferences" and proably "Thunar/accels.scm" and perhaps some "xfconf/xfce-perchannel-xml/"
ln -sfv ~/dotfiles/home/.mozilla/firefox/profile/user.js $HOME/.mozilla/firefox/$(grep -Pom1 'Default=\K[^1].+' ~/.mozilla/firefox/profiles.ini) || :
# todo: maybe add revese symlink (from system to this repo), but not mess with git.
sudo cp -Rv --preserve=mode,ownership,timestamps $HOME/dotfiles/etc/* /etc
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure console-setup -u
sudo update-grub
sudo lightdm --show-config

tmp_dir="$(mktemp -d)"; trap "\rm -rf \"$tmp_dir\"" EXIT INT TERM HUP
git clone --depth 1 https://github.com/sequencerr/XMousePasteBlock.git $tmp_dir || :
(cd $tmp_dir
sudo docker build --progress=plain -t xmousepasteblock --target export --output type=local,dest=. .
sudo apt-get install --yes libev-dev
sudo mv -fv ./xmousepasteblock /usr/bin)

lazydocker_release=$(wget --header 'Accept: application/json' -qO- https://github.com/jesseduffield/lazydocker/releases/latest | sed -e 's/.*"tag_name":"v\{0,1\}\([^"]*\)".*/\1/')
if ! command -v lazydocker > /dev/null || ! lazydocker --version | head -1 2> /dev/null | grep -q "$lazydocker_release"; then
    wget --show-progress -qO- "https://github.com/jesseduffield/lazydocker/releases/download/v$lazydocker_release/lazydocker_${lazydocker_release}_Linux_x86_64.tar.gz" | tar -xzf - -C $XDG_BINARY_HOME lazydocker
fi
lazydocker --version | head -1

glab_release=$(wget -qO- https://gitlab.com/api/v4/projects/gitlab-org%2Fcli/releases | grep -Po 'tag_name":\s*"v?\K[^"]+' | head -1)
if ! command -v gl > /dev/null || ! gl --version 2> /dev/null | grep -q "$glab_release"; then
    wget --show-progress -qO- "https://gitlab.com/gitlab-org/cli/-/releases/v$glab_release/downloads/glab_${glab_release}_linux_amd64.tar.gz" | tar -xzf - -C $XDG_BINARY_HOME --strip-components=1 --transform s/glab/gl/
fi
gl --version

zoxide_release=$(wget -qO- https://api.github.com/repos/ajeetdsouza/zoxide/releases/latest | grep -Po '^\s\s"name":\s"\K[^"]+')
if ! command -v zoxide > /dev/null || ! zoxide --version 2> /dev/null | grep -q "$zoxide_release"; then
    wget --show-progress -qO- "https://github.com/ajeetdsouza/zoxide/releases/latest/download/zoxide-$zoxide_release-x86_64-unknown-linux-musl.tar.gz" | tar xzf - -C $XDG_BINARY_HOME zoxide
    chmod +x $XDG_BINARY_HOME/zoxide
fi
zoxide --version

if ! command -v yt > /dev/null || ! yt --version 2> /dev/null | grep -q "$(wget -qO- https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest | grep -Po 'tag_name":\s*"\K[^"]+')"; then
    wget --show-progress -qO $XDG_BINARY_HOME/yt https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
    chmod +x $XDG_BINARY_HOME/yt
fi
yt --version

fnm_release=$(wget -qO- https://api.github.com/repos/Schniz/fnm/releases/latest | grep -Po '"tag_name":\s*"\K[^"]+')
if ! command -v fnm > /dev/null || ! fnm --version | grep -q "$(echo $fnm_release | sed 's/v//')"; then
    tmp_dir="$(mktemp -d)"; trap "\rm -rf \"$tmp_dir\"" EXIT INT TERM HUP
    wget --show-progress -qO "$tmp_dir/fnm.zip" "https://github.com/Schniz/fnm/releases/download/$fnm_release/fnm-linux.zip"
    busybox unzip -ojqd $XDG_BINARY_HOME "$tmp_dir/fnm.zip"
    chmod +x $XDG_BINARY_HOME/fnm
    fnm completions --shell bash > "$XDG_DATA_HOME/bash-completion/completions/fnm.bash"
fi
fnm --version
fnm install --latest
fnm install --lts
fnm install lts/iron     # 20.x
fnm install lts/hydrogen # 18.x
fnm install lts/gallium  # 16.x
node --completion-bash > "$XDG_DATA_HOME/bash-completion/completions/node.bash"
node --eval 'console.log(process.version, `(${process.release.lts})`)'

yarn_release=$(wget -qO- https://api.github.com/repos/yarnpkg/berry/releases/latest | grep -Po 'tag_name":\s*"\K[^"]+')
if ! command -v yarn > /dev/null || ! echo $yarn_release | grep -q "$(yarn --version)"; then
    wget --show-progress -qO $XDG_BINARY_HOME/yarn "https://raw.githubusercontent.com/yarnpkg/berry/refs/tags/$yarn_release/packages/yarnpkg-cli/bin/yarn.js"
    chmod +x $XDG_BINARY_HOME/yarn
fi
yarn --version

fnm exec --using=18 npm install -g pnpm
ln -sfv "$(find "$FNM_DIR/node-versions" -maxdepth 1 -name "v18*" -print -quit)/installation/bin/pnpm" $XDG_BINARY_HOME/pnpm
pnpm --version

bun_release=$(wget -qO- https://api.github.com/repos/oven-sh/bun/releases/latest | grep -Po '"tag_name":\s*"\K[^"]+')
if ! command -v bun > /dev/null || ! bun --version | grep -q "$(echo $bun_release | awk -F'[v]' '{print $NF}')"; then
    tmp_dir="$(mktemp -d)"; trap "\rm -rf \"$tmp_dir\"" EXIT INT TERM HUP
    wget --show-progress -qO $tmp_dir/bun.zip "https://github.com/oven-sh/bun/releases/download/$bun_release/bun-linux-x64.zip"
    busybox unzip -ojqd $BUN_INSTALL_BIN $tmp_dir/bun.zip
    chmod +x $BUN_INSTALL_BIN/bun
    SHELL=bash bun completions > "$XDG_DATA_HOME/bash-completion/completions/bun.bash"
fi
bun --eval 'console.log(Bun.version_with_sha)'

deno_release=$(wget -qO- https://dl.deno.land/release-latest.txt)
if ! command -v deno > /dev/null || ! deno -V | grep -q "$(echo $deno_release | cut -c2-)"; then
    wget --show-progress -qO- "https://dl.deno.land/release/$deno_release/deno-x86_64-unknown-linux-gnu.zip" | busybox unzip -ojqd $XDG_BINARY_HOME -
    chmod +x "$XDG_BINARY_HOME/deno"
    deno completions bash > "$XDG_DATA_HOME/bash-completion/completions/deno.bash"
fi
deno eval 'console.log(Deno.version.deno)'

sudo apt-get install --yes --no-install-recommends \
    openjdk-17-jdk java-21-amazon-corretto-jdk
sudo update-java-alternatives --set java-21-amazon-corretto
echo ${JAVA_HOME:-}
jshell -q <<< 'System.out.println("\n\n" + System.getProperty("java.version"));'

maven_release=$(wget -qO- https://api.github.com/repos/apache/maven/releases/latest | grep -Po '"name":\s*"(maven-)?\K[^"]+')
if ! command -v mvn > /dev/null || ! mvn --version | head -1 | grep -q "$maven_release"; then
    [ -d "$XDG_DATA_HOME/maven" ] && \rm -rfv $XDG_DATA_HOME/maven
    mkdir -pv $XDG_DATA_HOME/maven
    wget --show-progress -qO- "https://dlcdn.apache.org/maven/maven-$(echo $maven_release | cut -c1)/$maven_release/binaries/apache-maven-$maven_release-bin.tar.gz" | tar xzf - -C $XDG_DATA_HOME/maven --strip-components=1
    ln -sfv $XDG_DATA_HOME/maven/bin/mvn $XDG_BINARY_HOME/mvn
    # https://maven.apache.org/guides/mini/guide-bash-m2-completion.html
    wget https://raw.github.com/juven/maven-bash-completion/master/bash_completion.bash -qO "$XDG_DATA_HOME/bash-completion/completions/mvn"
fi
mvn --version

gradle_release=$(wget -qO- https://api.github.com/repos/gradle/gradle/releases/latest | grep -Po '"name":\s*"\K[^"]+')
if ! command -v gradle > /dev/null || ! gradle --version | awk 'NR==3' | grep -q "$gradle_release"; then
    wget --show-progress -qO- "https://services.gradle.org/distributions/gradle-$gradle_release-bin.zip" | busybox unzip -oqd $XDG_DATA_HOME -
    mv $XDG_DATA_HOME/gradle* $XDG_DATA_HOME/gradle
    chmod +x $XDG_DATA_HOME/gradle/bin/gradle
    ln -sfv $XDG_DATA_HOME/gradle/bin/gradle $XDG_BINARY_HOME/gradle
    wget https://raw.githubusercontent.com/gradle/gradle-completion/refs/heads/master/gradle-completion.bash -qO "$XDG_DATA_HOME/bash-completion/completions/gradle.bash"
fi
gradle --version

spring_release=$(wget -qO- https://api.github.com/repos/spring-projects/spring-boot/releases/latest | grep -Po '"tag_name":\s*"v?\K[^"]+')
if ! command -v spring > /dev/null || ! spring --version | grep -q "$spring_release"; then
    [ -d "$XDG_DATA_HOME/spring-boot-cli" ] && \rm -rfv $XDG_DATA_HOME/spring-boot-cli
    mkdir -pv $XDG_DATA_HOME/spring-boot-cli
    wget --show-progress -qO- "https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-cli/$spring_release/spring-boot-cli-$spring_release-bin.tar.gz" | tar -xzf - -C $XDG_DATA_HOME/spring-boot-cli --strip-components=1
    ln -sfv $XDG_DATA_HOME/spring-boot-cli/bin/spring $XDG_BINARY_HOME/spring
    ln -sfv $XDG_DATA_HOME/spring-boot-cli/shell-completion/bash/spring "$XDG_DATA_HOME/bash-completion/completions/spring.bash"
fi
spring --version

composer_release=$(wget -qO- https://api.github.com/repos/composer/composer/releases/latest | grep -Pom1 'name":\s*"\K[^"]+')
if ! command -v composer > /dev/null || ! composer --version 2> /dev/null | awk '{ print $3 }' | grep -q "$composer_release"; then
    sudo apt-get install --yes --no-install-recommends \
        php php-curl php-dom php-xml
    wget --show-progress -qO $XDG_BINARY_HOME/composer "https://getcomposer.org/download/$composer_release/composer.phar"
    chmod +x $XDG_BINARY_HOME/composer
    composer completion bash > "$XDG_DATA_HOME/bash-completion/completions/composer.bash"
fi
composer --version 2> /dev/null

IS_SUDOED=${IS_SUDOED:-}; [ $IS_SUDOED ] || finish
