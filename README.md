# Carcuis's dotfiles

This repository is a collection of my personal configuration files for various tools and environments.
Various scripts are provided to help sync these files between different operating systems like Windows, Linux and MacOS.

## Contents

* [Neovim (vim) config](./.vimrc)
* [oh-my-zsh config](./.zshrc)
* [PowerShell profile](./windows/powershell/Microsoft.PowerShell_profile.ps1)
* [VSCode settings](./vscode/)
* [WSL2 config](./windows/wsl/)
* [IdeaVim config](./dot_files/.ideavimrc)
* [Termux shortcuts](./android/.shortcuts)
* [Tmux config](./.config/tmux/tmux.conf)
* [Edge extension settings](./web/)
* And more...

## Requirements

* [neovim](https://neovim.io/) >= v0.10
  * [ripgrep](https://github.com/BurntSushi/ripgrep)
  * [fd](https://github.com/sharkdp/fd)
  * [fzf](https://github.com/junegunn/fzf)
  * [nodejs](https://nodejs.org/)
  * C++ compiler (for some plugins)
* [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts/releases) >= v3.3.0
* [Vifm](https://vifm.info/)
* [Yazi](https://yazi-rs.github.io/docs/installation) >= v0.4.0
  * [FFmpeg](https://www.ffmpeg.org/)
  * [7-Zip](https://www.7-zip.org/)
  * [jq](https://jqlang.github.io/jq/)
  * [Poppler](https://poppler.freedesktop.org/)
  * [ImageMagick](https://imagemagick.org/)
  * [MediaInfo](https://github.com/MediaArea/MediaInfo)
  * [ExifTool](https://exiftool.org/)
* [lazygit](https://github.com/jesseduffield/lazygit) >= v0.45
  * [delta](https://github.com/dandavison/delta)
* [tmux](https://github.com/tmux/tmux/wiki) >= v3.2
  * [yq](https://github.com/mikefarah/yq)

## Installation

```bash
./setup.sh
```

## Run sync

```bash
./check_consistency.sh # [-a|v|f|h]

# or
csc # [-v|f|h]  # symlinked to scripts/check_all.sh

# or
csup # [-v|f|h]  # symlinked to scripts/update.sh
```
