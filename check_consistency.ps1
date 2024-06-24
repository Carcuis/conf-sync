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
$file_list = @(
    $psprofile
    $vimrc
)
$extra_file_list = @(
    $windows_psprofile_v5
    $ohmyposh_theme
    $coc_settings
    $ptpython
    $ideavimrc
    $lazygit
    $git_config
    $vifmrc
)

function Mesg    { param($msg) Write-Host "$WHITE$msg$TAIL"       }
function Info    { param($msg) if ($verbose) { Mesg "$CYAN$msg" } }
function Bold    { param($msg) Mesg "$BOLD$msg"                   }
function Success { param($msg) Bold "$GREEN$msg ✔"                }
function Warning { param($msg) Bold "$YELLOW$msg"                 }
function Error   { param($msg) Bold "$RED$msg"                    }

function Usage {
    Bold "Usage:"
    Mesg "  check_consistency.ps1 [options]"
    Mesg
    Bold "Options:"
    Mesg "  -a, --all        Check all files"
    Mesg "  -h, --help       Display help"
    Mesg "  -v, --verbose    Show detailed information"
}

function CmdParser {
    foreach ($arg in $args) {
        switch -Regex ($arg) {
            "^(-?a)?(--all)?$"      { $script:file_list += $extra_file_list }
            "^(-?h)?(--help)?$"     { Usage; exit 0 }
            "^(-?v)?(--verbose)?$"  { $script:verbose = $true }
            default { Error "Error: Invalid option '$arg'"; Usage; exit 1 }
        }
    }
}

function HasCommand { param($cmd)           return (Get-Command $cmd).length -gt 0                           }
function HasDir     { param($dir)           return [System.IO.Path]::Exists($dir)                            }
function HasFile    { param($file)          return [System.IO.File]::Exists($file)                           }
function FileSame   { param($file1, $file2) return (Get-FileHash $file1).hash -eq (Get-FileHash $file2).hash }

function RunDiffAll {
    foreach ($file in $file_list) {
        if (! (HasFile $file.local)) { return $false }
        if (! (FileSame $file.remote $file.local)) { return $false }
    }
    return $true
}

function CheckEditor {
    if (HasCommand nvim) {
        $script:diff_command = "nvim -d"
    } elseif ((Get-Command vim).length -gt 0) {
        $script:diff_command = "vimdiff"
    } else {
        Error "Error: vim or nvim not found."
        exit 1
    }
}

function DiffFunc {
    param($file1, $file2)
    if ($diff_command -eq "nvim -d")
    {
        nvim -d $file1 $file2
    } elseif ($diff_command -eq "vimdiff")
    {
        vimdiff $file1 $file2
    }
}

function RunEdit {
    if (RunDiffAll) {
        Success "All files are the same. Nothing to do."
        exit
    }

    foreach ($file in $file_list) {
        if (! (HasFile $file.local)) {
            $file_local_dir = Split-Path $file.local
            Write-Host -NoNewline "$($file.name) not found, create a copy to $($file.local) ? [Y/n] "
            $user_input = [Console]::ReadKey()
            Mesg
            if ($user_input.Key -eq "Y" -or $user_input.Key -eq "Enter") {
                if (! (HasDir $file_local_dir)) {
                    Info "$file_local_dir not found, creating..."
                    New-Item -ItemType "directory" -Path $file_local_dir
                }
                Copy-Item -Path $file.remote -Destination $file.local
                Success "Copied ``$($file.remote)`` to ``$($file.local)``."
            }
            continue
        }

        if (FileSame $file.remote $file.local) {
            if ($verbose) { Success "$($file.name) has already been synchronized." }
        } else {
            Write-Host -NoNewline "$($file.name) unsynchronized. Edit with $diff_command ? [Y/n] "
            $user_input = [Console]::ReadKey()
            Mesg
            if ($user_input.Key -eq "Y" -or $user_input.Key -eq "Enter") {
                DiffFunc -file1 $file.remote -file2 $file.local
                if (FileSame $file.remote $file.local) {
                    Success "$($file.name) is now synchronized."
                } else {
                    Info "$($file.name) is still unsynchronized."
                    Info "-- Use ``$diff_command $($file.remote) $($file.local)`` later,"
                    Info "-- or try to rerun this wizard."
                }
            }
        }
    }

    if (RunDiffAll) {
        Success "All files are synchronized now."
    }
}

# main
CmdParser $args
CheckEditor
RunEdit
