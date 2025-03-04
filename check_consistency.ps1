$DIR = Get-Item $PSCommandPath | Select-Object -ExpandProperty Target | Split-Path -Parent
if (! $DIR) { $DIR = $PSScriptRoot }

$script:verbose = $false
$script:force_sync = $false
$script:diff_command = ""
$script:scoop_root = ""

$BOLD = "`e[1m" ; $TAIL  = "`e[0m" ; $WHITE  = "`e[37m"
$RED  = "`e[31m"; $GREEN = "`e[32m"; $YELLOW = "`e[33m"; $CYAN = "`e[36m"

function Get-Scoop-Root {
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Host "${BOLD}${RED}Error: scoop not found.${TAIL}"
        exit 1
    }
    $script:scoop_root = scoop config root_path
}
Get-Scoop-Root

$psprofile = @{
    name = "PSProfile"
    remote = "$DIR\windows\powershell\Microsoft.PowerShell_profile.ps1"
    local = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
}
$windows_psprofile_v5 = @{
    name = "Windows Powershell (v5) Profile"
    remote = "$DIR\windows\powershell\Microsoft.PowerShell_profile.windows_powershell_v5.ps1"
    local = "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
}
$wsl_config = @{
    name = "WSL Configuration"
    remote = "$DIR\windows\wsl\.wslconfig"
    local = "$HOME\.wslconfig"
}
$ohmyposh_theme = @{
    name = "oh-my-posh theme"
    remote = "$DIR\windows\powershell\cui_theme.omp.json"
    local = "$HOME\.config\ohmyposh\themes\cui_theme.omp.json"
}
$vimrc = @{
    name = "vimrc"
    remote = "$DIR\.vimrc"
    local = "$HOME\_vimrc"
}
$coc_settings = @{
    name = "coc-settings.json"
    remote = "$DIR\.config\nvim\coc-settings.json"
    local = "$HOME\AppData\Local\nvim\coc-settings.json"
}
$ptpython = @{
    name = "PtPython config.py"
    remote = "$DIR\.config\ptpython\config.py"
    local = "$HOME\AppData\Local\prompt_toolkit\ptpython\config.py"
}
$ideavimrc = @{
    name = "ideavimrc"
    remote = "$DIR\dot_files\.ideavimrc"
    local = "$HOME\.ideavimrc"
}
$lazygit = @{
    name = "lazygit config.yml"
    remote = "$DIR\.config\lazygit\config.yml"
    local = "$HOME\AppData\Roaming\lazygit\config.yml"
}
$git_config = @{
    name = "Globle git config"
    remote = "$DIR\dot_files\.gitconfig"
    local = "$HOME\.gitconfig"
}
$vifmrc = @{
    name = "vifmrc"
    remote = "$DIR\.config\vifm\vifmrc"
    local = "$HOME\AppData\Roaming\Vifm\vifmrc"
}
$clangd = @{
    name = "clangd config.yaml"
    remote = "$DIR\windows\clangd\config.yaml"
    local = "$HOME\AppData\Local\clangd\config.yaml"
}
$tealdeer = @{
    name = "tealdeer config.toml"
    remote = "$DIR\.config\tealdeer\config.toml"
    local = "$script:scoop_root\persist\tealdeer\config.toml"
}
$condarc = @{
    name = "condarc"
    remote = "$DIR\dot_files\.condarc"
    local = "$HOME\.condarc"
}
$yazi_init = @{
    name = "yazi init.lua"
    remote = "$DIR\.config\yazi\init.lua"
    local = "$HOME\AppData\Roaming\yazi\config\init.lua"
}
$yazi_config = @{
    name = "yazi yazi.toml"
    remote = "$DIR\.config\yazi\yazi.toml"
    local = "$HOME\AppData\Roaming\yazi\config\yazi.toml"
}
$yazi_keymap = @{
    name = "yazi keymap.toml"
    remote = "$DIR\.config\yazi\keymap.toml"
    local = "$HOME\AppData\Roaming\yazi\config\keymap.toml"
}
$yazi_theme = @{
    name = "yazi theme.toml"
    remote = "$DIR\.config\yazi\theme.toml"
    local = "$HOME\AppData\Roaming\yazi\config\theme.toml"
}
$vscode_nvim_lua = @{
    name = "vscode-neovim lua config"
    remote = "$DIR\vscode\vscode.nvim.lua"
    local = "$HOME\.vscode\vscode.nvim.lua"
}
$vscode_keybindings = @{
    name = "vscode keybindings.json"
    remote = "$DIR\vscode\keybindings.json"
    local = "$HOME\AppData\Roaming\Code\User\keybindings.json"
}
$vscode_settings = @{
    name = "vscode settings.json"
    remote = "$DIR\vscode\settings.json"
    local = "$HOME\AppData\Roaming\Code\User\settings.json"
}
$file_list = @(
    $psprofile
    $vimrc
)
$extra_file_list = @(
    $windows_psprofile_v5
    $wsl_config
    $ohmyposh_theme
    $coc_settings
    $ptpython
    $ideavimrc
    $lazygit
    $git_config
    $vifmrc
    $clangd
    $tealdeer
    $condarc
    $yazi_init
    $yazi_config
    $yazi_keymap
    $yazi_theme
    $vscode_nvim_lua
    $vscode_keybindings
    $vscode_settings
)

function Print-Line    { param([string]$msg) Write-Host "$WHITE$msg$TAIL"             }
function Print-Info    { param([string]$msg) if ($script:verbose) { Print-Line "$CYAN$msg" } }
function Print-Bold    { param([string]$msg) Print-Line "$BOLD$msg"                   }
function Print-Success { param([string]$msg) Print-Bold "$GREEN$msg ✔"                }
function Print-Warning { param([string]$msg) Print-Bold "$YELLOW$msg"                 }
function Print-Error   { param([string]$msg) Print-Bold "$RED$msg"                    }

function Show-Usage {
    Print-Bold "Usage:"
    Print-Line "  check_consistency.ps1 [options]"
    Print-Line
    Print-Bold "Options:"
    Print-Line "  -a, --all        Check all files"
    Print-Line "  -f, --force-sync Force sync files"
    Print-Line "  -h, --help       Display help"
    Print-Line "  -s, --status     Show status of all files"
    Print-Line "  -v, --verbose    Show detailed information"
}

function Command-Parser {
    if (-not $args -or -not $args.Split) { return }

    foreach ($arg in $args.Split(" ")) {
        switch -Regex ($arg) {
            "^((-?a)|(-?-all))$"      { $script:file_list += $extra_file_list }
            "^((-?f)|(-?-force))$"    { $script:force_sync = $true }
            "^((-?h)|(-?-help))$"     { Show-Usage; exit 0 }
            "^((-?s)|(-?-status))$"   { if (Check-All-Files) { Write-Output "All synchronized." } else { Write-Output "Unsynchronized." }; exit 0 }
            "^((-?v)|(-?-verbose))$"  { $script:verbose = $true }
            default { Print-Error "Error: Invalid option '$arg'"; Show-Usage; exit 1 }
        }
    }
}

function Has-Command { param([string]$cmd)   return (Get-Command $cmd).length -gt 0 }
function Has-Dir     { param([string]$dir)   return [System.IO.Path]::Exists($dir)  }
function Has-File    { param([string]$file)  return [System.IO.File]::Exists($file) }
function File-Same   { param([string]$file1, [string]$file2) return (Get-FileHash $file1).hash -eq (Get-FileHash $file2).hash }
function Ensure-Dir  { param([string]$dir)   if (! (Has-Dir $dir)) { New-Item -ItemType "directory" -Path $dir | Out-Null } }

function Check-All-Files {
    foreach ($file in $file_list) {
        if (! (Has-File $file.local)) { return $false }
        if (! (File-Same $file.remote $file.local)) { return $false }
    }
    return $true
}

function Check-Editor {
    if (Has-Command nvim) {
        $script:diff_command = "nvim -i NONE -d"
    } elseif (Has-Command vim) {
        $script:diff_command = "vimdiff"
    } else {
        Print-Error "Error: vim or nvim not found."
        exit 1
    }
}

function Read-Input-Key {
    param(
        [string]$message
    )
    Write-Host -NoNewline "$message"
    $user_input = [Console]::ReadKey()
    Print-Line
    return $user_input.Key
}

function Confirm-Action {
    param(
        [string]$message
    )
    if ($script:force_sync) { return $true }
    $input_key = Read-Input-Key "$message [Y/n] "
    return ($input_key -eq "Y" -or $input_key -eq "Enter")
}

function Run-Diff {
    param(
        [string]$file1,
        [string]$file2
    )

    if ($script:force_sync) {
        $dest_dir = Split-Path -Parent $file2
        $backup_dir = Join-Path -Path $DIR -ChildPath "backup"

        Ensure-Dir $dest_dir
        Ensure-Dir $backup_dir

        if (Has-File $file2) {
            $backup_file = Join-Path -Path $backup_dir -ChildPath "$(Split-Path -Leaf $file2).$(Get-Date -Format 'yyMMdd_HHmmss')"
            Move-Item -Path $file2 -Destination $backup_file
            Print-Info "Backuped `$dest` to `$backup_file`."
        }

        Copy-Item -Path $file1 -Destination $file2
        return
    }

    if ($script:diff_command -eq "nvim -i NONE -d")
    {
        nvim -i NONE -d $file1 $file2
    } elseif ($script:diff_command -eq "vimdiff")
    {
        vimdiff $file1 $file2
    } else {
        Print-Error "Error: diff command '$script:diff_command' not found."
        exit 1
    }
}

function Run-Edit {
    if (Check-All-Files) {
        Print-Success "All files are the same. Nothing to do."
        return
    }

    foreach ($file in $file_list) {
        if (! (Has-File $file.local)) {
            $file_local_dir = Split-Path $file.local
            if (Confirm-Action "$($file.name) not found, create a copy to $($file.local) ?") {
                if (! (Has-Dir $file_local_dir)) {
                    Print-Info "$file_local_dir not found, creating..."
                    New-Item -ItemType "directory" -Path $file_local_dir | Out-Null
                }
                Copy-Item -Path $file.remote -Destination $file.local
                Print-Success "Copied ``$($file.remote)`` to ``$($file.local)``."
            }
            continue
        }

        if (File-Same $file.remote $file.local) {
            if ($script:verbose) { Print-Success "$($file.name) has already been synchronized." }
        } else {
            if (Confirm-Action "$($file.name) unsynchronized. Edit with $script:diff_command ?") {
                Run-Diff -file1 $file.remote -file2 $file.local
                if (File-Same $file.remote $file.local) {
                    Print-Success "$($file.name) is now synchronized."
                } else {
                    Print-Info "$($file.name) is still unsynchronized."
                    Print-Info "-- Use ``$script:diff_command $($file.remote) $($file.local)`` later,"
                    Print-Info "-- or try to rerun this wizard."
                }
            }
        }
    }

    if (Check-All-Files) {
        Print-Success "All files are synchronized now."
    }
}

function Main {
    Command-Parser $args
    if (! $script:force_sync) { Check-Editor }
    Run-Edit
}

Main $args
