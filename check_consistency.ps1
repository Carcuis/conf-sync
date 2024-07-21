$verbose = $false
$diff_command = ""

$BOLD = "`e[1m" ; $TAIL  = "`e[0m" ; $WHITE  = "`e[37m"
$RED  = "`e[31m"; $GREEN = "`e[32m"; $YELLOW = "`e[33m"; $CYAN = "`e[36m"

$psprofile = @{
    name = "PSProfile"
    remote = "$PSScriptRoot\windows\powershell\Microsoft.PowerShell_profile.ps1"
    local = "$home\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
}
$windows_psprofile_v5 = @{
    name = "Windows Powershell (v5) Profile"
    remote = "$PSScriptRoot\windows\powershell\Microsoft.PowerShell_profile.windows_powershell_v5.ps1"
    local = "$home\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
}
$wsl_config = @{
    name = "WSL Configuration"
    remote = "$PSScriptRoot\windows\.wslconfig"
    local = "$home\.wslconfig"
}
$ohmyposh_theme = @{
    name = "oh-my-posh theme"
    remote = "$PSScriptRoot\windows\powershell\cui_theme.omp.json"
    local = "$home\AppData\Local\Programs\oh-my-posh\themes\cui_theme.omp.json"
}
$vimrc = @{
    name = "vimrc"
    remote = "$PSScriptRoot\.vimrc"
    local = "$home\_vimrc"
}
$coc_settings = @{
    name = "coc-settings.json"
    remote = "$PSScriptRoot\.config\nvim\coc-settings.json"
    local = "$home\AppData\Local\nvim\coc-settings.json"
}
$ptpython = @{
    name = "PtPython config.py"
    remote = "$PSScriptRoot\.config\ptpython\config.py"
    local = "$home\AppData\Local\prompt_toolkit\ptpython\config.py"
}
$ideavimrc = @{
    name = "ideavimrc"
    remote = "$PSScriptRoot\dot_files\.ideavimrc"
    local = "$home\.ideavimrc"
}
$lazygit = @{
    name = "lazygit config.yml"
    remote = "$PSScriptRoot\.config\lazygit\config.yml"
    local = "$home\AppData\Roaming\lazygit\config.yml"
}
$git_config = @{
    name = "Globle git config"
    remote = "$PSScriptRoot\dot_files\.gitconfig"
    local = "$home\.gitconfig"
}
$vifmrc = @{
    name = "vifmrc"
    remote = "$PSScriptRoot\.config\vifm\vifmrc"
    local = "$home\AppData\Roaming\Vifm\vifmrc"
}
$clangd = @{
    name = "clangd config.yaml"
    remote = "$PSScriptRoot\windows\clangd\config.yaml"
    local = "$home\AppData\Local\clangd\config.yaml"
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
)

function Print-Line    { param($msg) Write-Host "$WHITE$msg$TAIL"             }
function Print-Info    { param($msg) if ($verbose) { Print-Line "$CYAN$msg" } }
function Print-Bold    { param($msg) Print-Line "$BOLD$msg"                   }
function Print-Success { param($msg) Print-Bold "$GREEN$msg ✔"                }
function Print-Warning { param($msg) Print-Bold "$YELLOW$msg"                 }
function Print-Error   { param($msg) Print-Bold "$RED$msg"                    }

function Show-Usage {
    Print-Bold "Usage:"
    Print-Line "  check_consistency.ps1 [options]"
    Print-Line
    Print-Bold "Options:"
    Print-Line "  -a, --all        Check all files"
    Print-Line "  -h, --help       Display help"
    Print-Line "  -v, --verbose    Show detailed information"
}

function Command-Parser {
    foreach ($arg in $args) {
        switch -Regex ($arg) {
            "^(-?a)?(--all)?$"      { $script:file_list += $extra_file_list }
            "^(-?h)?(--help)?$"     { Show-Usage; exit 0 }
            "^(-?v)?(--verbose)?$"  { $script:verbose = $true }
            default { Print-Error "Error: Invalid option '$arg'"; Show-Usage; exit 1 }
        }
    }
}

function Has-Command { param($cmd)           return (Get-Command $cmd).length -gt 0                           }
function Has-Dir     { param($dir)           return [System.IO.Path]::Exists($dir)                            }
function Has-File    { param($file)          return [System.IO.File]::Exists($file)                           }
function File-Same   { param($file1, $file2) return (Get-FileHash $file1).hash -eq (Get-FileHash $file2).hash }

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
    param($message)
    Write-Host -NoNewline "$message"
    $user_input = [Console]::ReadKey()
    Print-Line
    return $user_input.Key
}

function Run-Diff {
    param($file1, $file2)
    if ($diff_command -eq "nvim -i NONE -d")
    {
        nvim -i NONE -d $file1 $file2
    } elseif ($diff_command -eq "vimdiff")
    {
        vimdiff $file1 $file2
    }
}

function Run-Edit {
    if (Check-All-Files) {
        Print-Success "All files are the same. Nothing to do."
        exit
    }

    foreach ($file in $file_list) {
        if (! (Has-File $file.local)) {
            $file_local_dir = Split-Path $file.local
            $input_key = Read-Input-Key "$($file.name) not found, create a copy to $($file.local) ? [Y/n] "
            if ($input_key -eq "Y" -or $input_key -eq "Enter") {
                if (! (Has-Dir $file_local_dir)) {
                    Print-Info "$file_local_dir not found, creating..."
                    New-Item -ItemType "directory" -Path $file_local_dir
                }
                Copy-Item -Path $file.remote -Destination $file.local
                Print-Success "Copied ``$($file.remote)`` to ``$($file.local)``."
            }
            continue
        }

        if (File-Same $file.remote $file.local) {
            if ($verbose) { Print-Success "$($file.name) has already been synchronized." }
        } else {
            $input_key = Read-Input-Key "$($file.name) unsynchronized. Edit with $diff_command ? [Y/n] "
            if ($input_key -eq "Y" -or $input_key -eq "Enter") {
                Run-Diff -file1 $file.remote -file2 $file.local
                if (File-Same $file.remote $file.local) {
                    Print-Success "$($file.name) is now synchronized."
                } else {
                    Print-Info "$($file.name) is still unsynchronized."
                    Print-Info "-- Use ``$diff_command $($file.remote) $($file.local)`` later,"
                    Print-Info "-- or try to rerun this wizard."
                }
            }
        }
    }

    if (Check-All-Files) {
        Print-Success "All files are synchronized now."
    }
}

# main
Command-Parser $args
Check-Editor
Run-Edit
