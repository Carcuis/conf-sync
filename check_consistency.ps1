$DIR = Get-Item $PSCommandPath | Select-Object -ExpandProperty Target | Split-Path -Parent
if (! $DIR) { $DIR = $PSScriptRoot }

Import-Module (Join-Path $DIR "modules\util.psm1") -Scope Local -Force

$global:verbose = $false
$script:force_sync = $false
$script:diff_command = ""
$script:scoop_root = Get-ScoopRoot

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
    local = "$HOME\Appdata\Local\vscnvim\init.lua"
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

function Show-Usage {
    Write-Bold "Usage:"
    Write-Line "  check_consistency.ps1 [options]"
    Write-Line
    Write-Bold "Options:"
    Write-Line "  -a, --all        Check all files"
    Write-Line "  -f, --force-sync Force sync files"
    Write-Line "  -h, --help       Display help"
    Write-Line "  -s, --status     Show status of all files"
    Write-Line "  -v, --verbose    Show detailed information"
}

function Invoke-CmdPaser {
    if (-not $args -or -not $args.Split) { return }

    foreach ($arg in $args.Split(" ")) {
        switch -Regex ($arg) {
            "^((-?a)|(-?-all))$"      { $script:file_list += $extra_file_list }
            "^((-?f)|(-?-force))$"    { $script:force_sync = $true }
            "^((-?h)|(-?-help))$"     { Show-Usage; exit 0 }
            "^((-?v)|(-?-verbose))$"  { $global:verbose = $true }

            "^((-?s)|(-?-status))$"   {
                if (Test-AllSynced) {
                    Write-Line "All synchronized."
                } else {
                    Write-Line "Unsynchronized."
                }
                exit 0
            }

            default { Write-ErrorMsg "Error: Invalid option '$arg'"; Show-Usage; exit 1 }
        }
    }
}

function Test-AllSynced {
    foreach ($file in $file_list) {
        if (! (Test-HasFile $file.local)) { return $false }
        if (! (Test-FileSame $file.remote $file.local)) { return $false }
    }
    return $true
}

function Set-DiffCommand {
    if ($script:force_sync) { return }

    if (Test-HasCommand nvim) {
        $script:diff_command = "nvim -i NONE -d"
    } elseif (Test-HasCommand vim) {
        $script:diff_command = "vimdiff"
    } else {
        Write-ErrorMsg "Error: vim or nvim not found."
        exit 1
    }
}

function Confirm-Action {
    param(
        [string]$message
    )
    if ($script:force_sync) { return $true }
    $input_key = Read-InputKey "$message [Y/n] "
    return ($input_key -eq "Y" -or $input_key -eq "Enter")
}

function Invoke-RunDiff {
    param(
        [string]$file1,
        [string]$file2
    )

    if ($script:force_sync) {
        $dest_dir = Split-Path -Parent $file2
        Invoke-EnsureDir $dest_dir

        Invoke-ExistAndBackup $file2

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
        Write-ErrorMsg "Error: diff command '$script:diff_command' not found."
        exit 1
    }
}

function Invoke-RunSync {
    if (Test-AllSynced) {
        Write-Success "All files are the same. Nothing to do."
        return
    }

    foreach ($file in $file_list) {
        if (! (Test-HasFile $file.local)) {
            $file_local_dir = Split-Path $file.local
            if (Confirm-Action "$($file.name) not found, create a copy to $($file.local) ?") {
                if (! (Has-Dir $file_local_dir)) {
                    Write-Info "$file_local_dir not found, creating..."
                    New-Item -ItemType "directory" -Path $file_local_dir | Out-Null
                }
                Copy-Item -Path $file.remote -Destination $file.local
                Write-Success "Copied ``$($file.remote)`` to ``$($file.local)``."
            }
            continue
        }

        if (Test-FileSame $file.remote $file.local) {
            if ($global:verbose) { Write-Success "$($file.name) has already been synchronized." }
        } else {
            if (Confirm-Action "$($file.name) unsynchronized. Edit with $script:diff_command ?") {
                Invoke-RunDiff -file1 $file.remote -file2 $file.local
                if (Test-FileSame $file.remote $file.local) {
                    Write-Success "$($file.name) is now synchronized."
                } else {
                    Write-Info "$($file.name) is still unsynchronized."
                    Write-Info "-- Use ``$script:diff_command $($file.remote) $($file.local)`` later,"
                    Write-Info "-- or try to rerun this wizard."
                }
            }
        }
    }

    if (Test-AllSynced) {
        Write-Success "All files are synchronized now."
    }
}

function Invoke-Main {
    Invoke-CmdPaser $args
    Set-DiffCommand
    Invoke-RunSync
    Remove-Globals
}

Invoke-Main $args
