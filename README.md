# Dotfiles

## 一键部署 (bootstrap.sh)

```bash
#!/usr/bin/env bash
git clone --bare git@github.com:eric/dotfiles.git $HOME/.dotfiles
function dot(){ /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME "$@"; }
dot checkout
dot config status.showUntrackedFiles no
```
