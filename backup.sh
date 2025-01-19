find ~/dotfiles/home -type f -exec sh -c 'cp -v "$HOME/$(realpath --relative-to="$HOME/dotfiles/home" "{}")" "{}"' \; 2>&1 | grep -v theme
find ~/dotfiles/etc -type f -exec sh -c 'cp -v "/etc/$(realpath --relative-to="$HOME/dotfiles/etc" "{}")" "{}"' \;
