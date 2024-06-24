# conf-sync

## Sync `configure`/`rc`/`dot` files between Windows, GNU/Linux distros and MacOS

### Two simple script for windows and unix

On Windows: to use `nvim -d` to quick compare pwsh `profile.ps1` and `_vimrc` relatively in remote repository and local home directory, simply run:

```powershell
conf-sync> .\check_consistency.ps1    # add `-a` to compare extra files
```

On Linux, macOS and Termux: to use `nvim -d` to quick compare `.zshrc` and `.vimrc` relatively in remote repository and local home directory, simply run:

```zsh
conf-sync% ./check_consistency.sh    # add `-a` to compare extra files
```

### And a set-up script for `oh-my-zsh` and more with `zsh` pre-installed

```zsh
conf-sync% ./setup.sh
```

