# conf-sync
## Sync `configure`/`rc`/`dot` files between Windows, GNU/Linux distros and MacOS.

### Two simple script for windows and unix:

On Windows: to use `vimdiff` to quick compare pwsh profile `.ps1` and `_vimrc` in remote repo and local homedir, simply run:

```powershell
conf-sync> .\check_consistency.ps1
```

On Unix: to use `vimdiff` to quick compare `.zshrc` and `.vimrc` in remote repo and local homedir, simply run:

```zsh
conf-sync% ./check_consistency.sh
```

### And a set-up script for `oh-my-zsh` and more with `zsh` pre-installed.

```zsh
conf-sync% ./setup_dependency.zsh
```

