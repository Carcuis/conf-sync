oh-my-posh init pwsh --config "$HOME\.config\ohmyposh\themes\cui_theme.omp.json" | Invoke-Expression

$env:EDITOR = "nvim"
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1

Import-Module -Name Terminal-Icons
Import-Module -Name CompletionPredictor
Import-Module -Name git-aliases-plus -DisableNameChecking
Import-Module -Name posh-git -arg 0,0,1
Import-Module -Name scoop-completion
Import-Module -Name WSLTabCompletion

Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$true
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key "Ctrl+LeftArrow" -Function BackwardWord
Set-PSReadLineKeyHandler -Key "Ctrl+RightArrow" -Function ForwardWord
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function DeleteCharOrExit
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r' -PSReadlineChordSetLocation 'Alt+c'

(Get-quote).TrimEnd() | cowsay -f moose -W 80 | lolcat

function Has-Command {
    param(
        [string] $command
    )
    if ((Get-Command $command -ErrorAction SilentlyContinue).length -gt 0) {
        return $true
    }
    return $false
}

function Has-File {
    param(
        [string] $file
    )
    if (Test-Path -Path $file -PathType Leaf -ErrorAction SilentlyContinue) {
        return $true
    }
    return $false
}

function Has-Dir {
    param(
        [string] $dir
    )
    if (Test-Path -Path $dir -PathType Container -ErrorAction SilentlyContinue) {
        return $true
    }
    return $false
}

function EditFile
{
    param($file)
    if (Has-Command nvim) {
        nvim $file
    } elseif (Has-Command vim) {
        vim $file
    } elseif (Has-Command gvim) {
        code $file
    } else {
        notepad.exe $file
    }
}

function ListDir { Get-ChildItem | Format-Wide -AutoSize }
function ListAll { Get-ChildItem -Force | Format-Wide -AutoSize }
function LLDir { Get-ChildItem }
function LLAll { Get-ChildItem -Force }
function GoUpOne { Set-Location .. }
function GoUpTwo { Set-Location ..\.. }
function GoUpThree { Set-Location ..\..\.. }
function GoUpFour { Set-Location ..\..\..\.. }
function OpenCwd { explorer.exe . }
function EditProfile { EditFile $profile }
function EditVimrc { EditFile $HOME\_vimrc }
function EditHistory { EditFile (Get-PSReadLineOption).HistorySavePath }
function OpenVifmInPwd { vifm.exe . }
function ReloadProfile { . $profile }
function GetAdminPriv { Start-Process pwsh -Verb runAs }
function StartSshServiceInWsl { wsl -- sudo service ssh start }
function StopSshServiceInWsl { wsl -- sudo service ssh stop }
function SetProxyOn {
    $proxy_server = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings').ProxyServer
    $proxy_port = $proxy_server -split ':' | Select-Object -Last 1
    $env:ALL_PROXY = "http://$proxy_server"
    $env:HTTP_PROXY = "http://$proxy_server"
    $env:HTTPS_PROXY = "http://$proxy_server"
    $env:PROXY_PORT = $proxy_port
}
function SetProxyOff {
    $env:ALL_PROXY = ""
    $env:HTTP_PROXY = ""
    $env:HTTPS_PROXY = ""
    $env:PROXY_PORT = ""
}
function WebDetection {
    $web_list = @(
        "https://www.baidu.com"
        "https://www.google.com"
        "https://github.com"
    )

    foreach ($web in $web_list) {
        try {
            Write-Host -NoNewline "[TEST] $web ... "
            $status = Invoke-WebRequest -Uri $web -DisableKeepAlive -Method Head -TimeoutSec 10 | ForEach-Object {$_.StatusCode}
            if ($status -eq 200) {
                Write-Host "OK" -ForegroundColor Green
            }
        }
        catch {
            Write-Host "FAIL" -ForegroundColor Red
        }
    }
}
function Conda-Hook {
    conda shell.powershell hook | Out-String | Where-Object {$_} | Invoke-Expression
}
function Conda-Hooked {
    if ($env:CONDA_EXE) {
        return $true
    }
    return $false
}
function Has-Virtual-Env {
    if ($env:VIRTUAL_ENV) {
        return $true
    }
    return $false
}
function Has-Conda-Env{
    if ($env:CONDA_DEFAULT_ENV) {
        return $true
    }
    return $false
}
function Check-Conda-Env-By-Name {
<#
.SYNOPSIS
    Check if a conda environment with the given name exists.
#>
    param(
        [string] $name
    )
    if (!(Has-Command conda)) {
        return $false
    }
    if ($name -eq "base") {
        return $true
    }
    $env_file = "$HOME\.conda\environments.txt"
    if (Has-File $env_file) {
        $env_paths = Get-Content -Path $env_file
        $env_path = $env_paths | Where-Object { $_ -match ".*\\$name$" }
        if (Has-Dir $env_path) {
            return $true
        }
    }
    return $false
}
function Create-Link($target, $link) {
    New-Item -ItemType SymbolicLink -Path $link -Value $target
}
function Move-And-Create-Link() {
    param(
        [string] $target,
        [string] $dest
    )

    if ($target -eq "" -and $dest -eq "") {
        Write-Host "Move file or directory to a new location and create a link on the original location,"
        Write-Host "    pointing to the new location.`n"
        Write-Host "Usage: Move-And-Create-Link [-target] <target> [-dest] <dest>`n"
        Write-Host "    -target: The file or directory to be moved. Should be absolute path."
        Write-Host "    -dest: The destination file or directory. Should be absolute path."
        return
    }

    if (!(Test-Path $target)) {
        Write-Error "Error: '$target' does not exist."
        return
    }

    if (!([System.IO.Path]::IsPathRooted($target) -and [System.IO.Path]::IsPathRooted($dest))) {
        Write-Error "Error: Both target and dest should be absolute paths."
        return
    }

    $target_is_file = Has-File $target
    $target_basename = Split-Path $target -Leaf

    $dest_is_file = Has-File $dest
    $dest_is_dir = Has-Dir $dest

    if ($target_is_file) {
        if ($dest_is_file) {
            Write-Error "Error: '$dest' already exists."
            return
        }
        if ($dest_is_dir) {
            Move-Item $target $dest
            Create-Link (Join-Path $dest $target_basename) $target
        } else { # $dest is a new file name
            Move-Item $target $dest
            Create-Link $dest $target
        }
    } else { # $target is a directory
        if ($dest_is_file) {
            Write-Error "Error: '$dest' is a existing file, cannot move."
            return
        }
        if ($dest_is_dir) {
            if (Test-Path (Join-Path $dest $target_basename)) {
                Write-Error "Error: A file or directory named '$target_basename' already exists in $dest ."
                return
            }
            Move-Item $target $dest
            Create-Link (Join-Path $dest $target_basename) $target
        } else { # $dest does not exist
            Move-Item $target $dest
            Create-Link $dest $target
        }
    }
}
function Sum-MD5($file) {
    $md5 = Get-FileHash -Algorithm MD5 -Path $file
    Write-Host "MD5 ($file) = $($md5.Hash)"
}
function Sum-SHA256($file) {
    $sha256 = Get-FileHash -Algorithm SHA256 -Path $file
    Write-Host "SHA256 ($file) = $($sha256.Hash)"
}
function Detect-And-Set-Proxy {
    $has_ie_proxy = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings').ProxyEnable
    if ($has_ie_proxy -eq 1) {
        SetProxyOn
    }
} Detect-And-Set-Proxy
function Update-TerminalSize-Env {
<#
.SYNOPSIS
    Update the environment variables 'TERMINAL_WIDTH' and 'TERMINAL_HEIGHT' with the current terminal size.
    Update the environment variable 'OHMYPOSH_MAX_PATH_LENGTH' with the maximum path length that can be displayed.
#>
    $width = $Host.UI.RawUI.WindowSize.Width
    $height = $Host.UI.RawUI.WindowSize.Height
    $OHMYPOSH_MAX_PATH_LENGTH = [Math]::Floor($width / 2)

    $cut_length = 0
    if (Has-Virtual-Env) {
        $venv_name = Split-Path -Parent $env:VIRTUAL_ENV | Split-Path -Leaf
        $cut_length += 13 + $venv_name.Length
    } elseif (Has-Conda-Env) {
        $conda_env_name = $env:CONDA_DEFAULT_ENV
        $cut_length += 15 + $conda_env_name.Length
    }
    if ((Get-GitDirectory).length -gt 0) {
        $cut_length += 15
    }
    if ($env:ALL_PROXY) {
        $cut_length += 4
    }
    $OHMYPOSH_MAX_PATH_LENGTH -= $cut_length

    $spare_length = 70
    $OHMYPOSH_MAX_PATH_LENGTH = [Math]::Min($OHMYPOSH_MAX_PATH_LENGTH, $width - $cut_length - $spare_length)

    [System.Environment]::SetEnvironmentVariable('TERMINAL_WIDTH', $width, 'Process')
    [System.Environment]::SetEnvironmentVariable('TERMINAL_HEIGHT', $height, 'Process')
    [System.Environment]::SetEnvironmentVariable('OHMYPOSH_MAX_PATH_LENGTH', $OHMYPOSH_MAX_PATH_LENGTH, 'Process')
} Update-TerminalSize-Env
function On-Enter {
    Update-TerminalSize-Env
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
} Set-PSReadLineKeyHandler -Key Enter -ScriptBlock { On-Enter }
function Make-Python-Venv {
    param(
        [string] $name = "venv"
    )
    if (!(Has-Command python)) {
        Write-Error "Error: Cannot find 'python' command."
        return
    }
    python -m venv $name
    Write-Output "Created venv in '$name'"
    Activate-Python-Venv -name $name
}
function Activate-Python-Venv {
    param(
        [string] $name = "venv",
        [string] $dir = $PWD,
        [switch] $silent
    )
    $venv_path = Join-Path -Path $dir -ChildPath $name
    if (Has-Dir $venv_path) {
        $activate_script = Join-Path -Path $venv_path -ChildPath "Scripts\Activate.ps1"
        if (Has-File $activate_script) {
            . $activate_script
            if (! $silent) {
                Write-Host "Activated virtual environment '$name'."
            }
        } elseif (! $silent) {
            Write-Error "Error: Cannot find 'Scripts\Activate.ps1' in $venv_path"
        }
    } elseif ($name -eq "venv") {
        if (! $silent) {
            Write-Error "Error: Cannot find 'venv' directory in $dir"
        }
    } else {
        if (Check-Conda-Env-By-Name -name $name) {
            if (Has-Virtual-Env) {
                Deactivate-Python-Venv
            }
            $_conda_hooked = $true
            if (! (Conda-Hooked)) {
                $_conda_hooked = $false
                Conda-Hook
            }
            if (("$name" -eq "base") -and -not $_conda_hooked) {
                Write-Host "Activated conda environment 'base'."
            } elseif ("$name" -eq $env:CONDA_DEFAULT_ENV) {
                Write-Host "Already activated conda environment '$name'."
            } else {
                if (Has-Conda-Env) {
                    conda deactivate
                }
                conda activate $name
                Write-Host "Activated conda environment '$name'."
            }
        } else {
            Write-Error "Error: Cannot find virtual environment '$name'."
        }
    }
    Update-TerminalSize-Env
}
function Deactivate-Python-Venv {
    if (Has-Virtual-Env) {
        if (Has-Command deactivate) {
            deactivate
        } else {
            Write-Error "Error: Cannot find 'deactivate' command."
        }
    } elseif (Has-Conda-Env) {
        conda deactivate
    } else {
        Write-Error "Error: No virtual environment is activated."
    }
    Update-TerminalSize-Env
}
function Auto-Change-Venv {
<#
.SYNOPSIS
    Automatically activate/deactivate virtual environment when changing directory.
#>
    param(
        [string] $dir
    )
    if (Has-Virtual-Env) {
        if ($dir -like "$(Split-Path -Path $env:VIRTUAL_ENV -Parent)*") {
            return
        } else {
            Deactivate-Python-Venv
        }
    }

    Activate-Python-Venv -dir $dir -name "venv" -silent
}
(Get-Variable PWD).Attributes.Add($(New-Object ValidateScript { Auto-Change-Venv $_; return $true }))
function Delete-Old-PSModules {
    Get-InstalledModule | ForEach-Object {
        $CurrentVersion = $PSItem.Version
        Get-InstalledModule -Name $PSItem.Name -AllVersions | Where-Object -Property Version -LT -Value $CurrentVersion
    } | Uninstall-Module -Verbose
}
function Remove-ItemRecurseForce {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    Remove-Item -Path $Path -Recurse -Force
}
function Generate-Srt {
    param (
        [string]$file,
        [string]$model = "",
        [string]$language = "en"
    )

    if ($file -eq "") {
        Write-Host "Generate SRT file from video/audio file(s).`n"
        Write-Host "Usage: Generate-Srt [-file] <file> [-model] <model> [-language] <language>`n"
        Write-Host "    -file: The video/audio file to be processed. Wildcards are supported.`n"
        Write-Host "    -model: The model to be used for processing. Default is auto-selected based on VRAM size.`n"
        Write-Host "    -language: The language of the audio. Default is 'en'.`n"
        return
    }

    $files = Get-Item $file -ErrorAction SilentlyContinue
    if ($files -eq $null) {
        Write-Error "Error: Cannot find '$file'."
        return
    }
    Write-Host "Total files: $(($files | Measure-Object).Count)"
    Foreach ($f in $files) {
        Write-Host "$f"
    }
    Write-Host

    $vram = 0
    $gpuName = "Unknown"

    # Retrieve information about the active graphics card
    try {
        $nvidiaSmiOutput = nvidia-smi --query-gpu=memory.total --format=csv,noheader
        if ($nvidiaSmiOutput -ne $null) {
            # Retrieve the VRAM size of the active graphics card in megabytes (MB)
            $vram = [math]::round($nvidiaSmiOutput.Trim() -replace " MiB", "")

            # Retrieve the name of the active graphics card
            $gpuName = (nvidia-smi --query-gpu=name --format=csv,noheader).Trim()
        }
    } catch {
        Write-Error "Failed to retrieve GPU information."
        Write-Error $_.Exception.Message
        return
    }

    if ($model -eq "") {
        # Select the appropriate model based on the VRAM size
        switch ($vram) {
            { $_ -lt 2048 } { $model = "base" }
            { $_ -lt 5120 } { $model = "small" }
            { $_ -lt 10240 } { $model = "medium" }
            default { $model = "large-v3" }
        }
    } else {
        # Check if the specified model can be used with the available VRAM
        $requiredVram = switch -Regex ($model) {
            "^tiny(\.en)?$" { 1024 }
            "^base(\.en)?$" { 1024 }
            "^small(\.en)?$" { 2048 }
            "^medium(\.en)?$" { 5120 }
            "^turbo$" { 6144 }
            "^large(-v[1-3])?$" { 10240 }
            default { Write-Error "Error: Invalid model '$model' specified."; return }
        }

        if ($vram -lt $requiredVram) {
            Write-Error "Error: Not enough VRAM for model '$model'. Required: $requiredVram MB, Available: $vram MB."
            return
        }
    }

    if (!(Has-Command whisper)) {
        Activate-Python-Venv -name "whisper"
        if (!(Has-Command whisper)) {
            Write-Error "Error: Cannot find 'whisper' command."
            return
        }
        Write-Host "Activated 'whisper' virtual environment.`n"
    }

    Write-Host "Using model '$model' for GPU '$gpuName' with $vram MB VRAM.`n"

    if ($files.Length -gt 1) {
        foreach ($f in $files) {
            Write-Host "`nProcessing file: $f`n"
            whisper --language $language --model $model -f srt $f.FullName
        }
    } else {
        Write-Host "`nProcessing file: $file`n"
        whisper --language $language --model $model -f srt $file.FullName
    }
}
function Ripgrep-Find-Files {
    param (
        [string]$pattern,
        [string]$glob = "!.git"
    )

    if (!(Has-Command rg)) {
        Write-Error "Error: Cannot find 'rg' command."
        return
    }

    if ($pattern -eq "") {
        Write-Host "Ripgrep find files with pattern in directory.`n"
        Write-Host "Usage: Ripgrep-Find-Files [-pattern] <pattern> [-glob] <pattern>`n"
        Write-Host "    -pattern: The pattern to search for."
        Write-Host "    -glob: The glob pattern of files to search. Default is '!git'."
        return
    }

    rg --files --hidden --glob $glob | rg --pcre2 $pattern
}
function Open-Environment-Variables {
    param (
        [switch] $sudo
    )
    if ($sudo) {
        Start-Process -Verb RunAs rundll32.exe "sysdm.cpl,EditEnvironmentVariables"
    } else {
        Start-Process rundll32.exe "sysdm.cpl,EditEnvironmentVariables"
    }
}
function Optimize-VHD {
<#
.SYNOPSIS
    Optimize the size of a WSL vhdx file by running the 'compact' command using Diskpart.
#>
    param (
        [string]$Path
    )

    # List running WSL distributions
    $runningDistrosLines = $(wsl --list --running) -split "`n"

    if ($runningDistrosLines.Count -le 3) {
        wsl --shutdown
    } else {
        $runningDistros = $runningDistrosLines[1..($runningDistrosLines.Length - 2)] -join "`n" -replace "貫", "Default"
        Write-Host "The following WSL distributions are currently running:"
        Write-Host $runningDistros
        $confirmShutdown = Read-Host "Shut down all running WSL distributions? (y/N)"
        if ($confirmShutdown -ne 'y') {
            Write-Host "Operation canceled."
            return
        }
        wsl --shutdown
    }

    # Automatically search for all Linux subsystem vhdx files
    if (-not $Path) {
        $vhdxFiles = Get-ChildItem -Path "$env:LOCALAPPDATA\Packages" -Recurse -Filter "*.vhdx" -ErrorAction SilentlyContinue

        if ($vhdxFiles.Count -eq 1) {
            $Path = $vhdxFiles.FullName
        } elseif ($vhdxFiles.Count -gt 1) {
            Write-Host "The following vhdx files were found, please select one:"
            for ($i = 0; $i -lt $vhdxFiles.Count; $i++) {
                Write-Host "$($i + 1). $($vhdxFiles[$i].FullName)"
            }
            $selection = Read-Host "Please enter the number"
            if ($selection -lt 1 -or $selection -gt $vhdxFiles.Count) {
                Write-Host "Invalid selection. Operation canceled."
                return
            }
            $Path = $vhdxFiles[$selection - 1].FullName
        } else {
            Write-Error "Error: No vhdx files found."
            return
        }
    } elseif (-not (Has-File $Path) -or -not ($Path -like "*.vhdx")) {
        Write-Error "Error: Invalid vhdx file path."
        return
    }

    $sizeBefore = (Get-Item $Path).Length

    # Create a script containing Diskpart commands
    $diskpartScript = @"
select vdisk file="$Path"
attach vdisk readonly
compact vdisk
detach vdisk
exit
"@

    # Save the script to a temporary file
    $tempFile = New-TemporaryFile
    Set-Content -Path $tempFile -Value $diskpartScript

    # Run the Diskpart script
    try {
        Start-Process -FilePath "diskpart" -ArgumentList "/s $tempFile" -Wait -Verb RunAs
    } catch {
        Write-Error $_.Exception.Message
        return
    } finally {
        Remove-Item -Path $tempFile
    }

    Write-Host "`nOptimization completed.✔`n"

    $sizeAfter = (Get-Item $Path).Length
    $sizeDifference = $sizeBefore - $sizeAfter

    Write-Host "Size before optimization:`t$($sizeBefore / 1GB)`tGB"
    Write-Host "Size after optimization:`t$($sizeAfter / 1GB)`tGB"
    Write-Host "Optimization saved:`t`t$($sizeDifference / 1GB)`tGB"
}
function Fzf-Ripgrep {
<#
.SYNOPSIS
    Use fzf to search words in files with ripgrep in the current directory.
    Need PSFzf module.
#>
    param (
        [string]$words = ""
    )
    if (!(Has-Command Invoke-PsFzfRipgrep)) {
        Write-Error "Error: Cannot find 'Invoke-PsFzfRipgrep' command."
        return
    }
    Invoke-PsFzfRipgrep $words
}
function Vscode-Nvim {
    if (!(Has-Command nvim)) {
        Write-Error "Error: Cannot find 'nvim' command."
        return
    }
    pwsh -NoLogo -NoProfile -NonInteractive -Command {
        $env:NVIM_APPNAME="vscnvim"
        nvim @Args
    } -Arg $Args
}
function CS-Check-All {
    $script = "$HOME\.local\bin\check_consistency.ps1"
    if (!(Has-File $script)) {
        Write-Error "Error: Cannot find 'check_consistency.ps1' script."
        return
    }

    function Show-Usage {
        Write-Host "Usage:"
        Write-Host "  CS-Check-All [options]"
        Write-Host
        Write-Host "Options:"
        Write-Host "  -f, --force-sync Force sync files"
        Write-Host "  -h, --help       Display help"
        Write-Host "  -v, --verbose    Show detailed information"
    }

    $params = "-a"
    foreach ($arg in $args) {
        switch -Regex ($arg) {
            "^((-?h)|(-?-help))$"     { Show-Usage; return }
            "^((-?f)|(-?-force))$"    { $params += " -f"; continue }
            "^((-?v)|(-?-verbose))$"  { $params += " -v"; continue }
            default { Write-Error "Error: Invalid option '$arg'"; Show-Usage; return }
        }
    }
    & $script $params
}
function CS-Update {
    $script = "$HOME\.local\bin\check_consistency.ps1"
    if (!(Has-File $script)) {
        Write-Error "Error: Cannot find 'check_consistency.ps1' script."
        return
    }

    function Show-Usage {
        Write-Host "Usage:"
        Write-Host "  CS-Update [options]"
        Write-Host
        Write-Host "Options:"
        Write-Host "  -f, --force-sync Force sync files"
        Write-Host "  -h, --help       Display help"
        Write-Host "  -v, --verbose    Show detailed information"
    }

    $params = "-a"
    foreach ($arg in $args) {
        switch -Regex ($arg) {
            "^((-?h)|(-?-help))$"     { Show-Usage; return }
            "^((-?f)|(-?-force))$"    { $params += " -f"; continue }
            "^((-?v)|(-?-verbose))$"  { $params += " -v"; continue }
            default { Write-Error "Error: Invalid option '$arg'"; Show-Usage; return }
        }
    }

    $output = & $script "-a -s"
    if ($output -eq "Unsynchronized.") {
        Write-Host "`e[1;33mThere are inconsistent files.`nPlease run 'csc' to sync them first.`e[0m"
        return
    }

    $repoDir = Get-Item $script | Select-Object -ExpandProperty Target | Split-Path -Parent
    if ((git -C $repoDir status -u --porcelain).Length -ne 0) {
        Write-Host "`e[1;33mThere are uncommitted changes in the repository.`nPlease commit or stash them first.`e[0m"
        return
    }

    git -C $repoDir pull --rebase

    & $script $params
}
function CS-Lazygit {
    $script = "$HOME\.local\bin\check_consistency.ps1"
    if (!(Has-File $script)) {
        Write-Error "Error: Cannot find 'check_consistency.ps1' script."
        return
    }

    $repoDir = Get-Item $script | Select-Object -ExpandProperty Target | Split-Path -Parent

    lazygit -p $repoDir
}

Set-Alias .. GoUpOne
Set-Alias ... GoUpTwo
Set-Alias .... GoUpThree
Set-Alias ..... GoUpFour
Set-Alias al ListAll
Set-Alias la ListAll
Set-Alias ls ListDir
Set-Alias l LLDir
Set-Alias ll LLAll
Set-Alias which Get-Command
Set-Alias o explorer.exe
Set-Alias o. OpenCwd
Set-Alias touch New-Item
Set-Alias vi vim
Set-Alias gvi gvim
Set-Alias pwshc EditProfile
Set-Alias vimc EditVimrc
Set-Alias histc EditHistory
Set-Alias nvi nvim
Set-Alias nvid neovide
Set-Alias gnvi nvim-qt
Set-Alias vif OpenVifmInPwd
Set-Alias vifm OpenVifmInPwd
Set-Alias src ReloadProfile
Set-Alias su GetAdminPriv
Set-Alias sshon StartSshServiceInWSl
Set-Alias sshoff StopSshServiceInWSl
Set-Alias px SetProxyOn
Set-Alias upx SetProxyOff
Set-Alias wd WebDetection
Set-Alias lg lazygit
Set-Alias lzd lazydocker
Set-Alias ipy ipython
Set-Alias pp ptpython
Set-Alias cdhk Conda-Hook
Set-Alias ln Create-Link
Set-Alias mvx Move-And-Create-Link
Set-Alias md5sum Sum-MD5
Set-Alias sha256sum Sum-SHA256
Set-Alias mkv Make-Python-Venv
Set-Alias vrun Activate-Python-Venv
Set-Alias dac Deactivate-Python-Venv
Set-Alias psmclo Delete-Old-PSModules
Set-Alias rm-rf Remove-ItemRecurseForce
Set-Alias ff fastfetch
Set-Alias of onefetch
Set-Alias yz yazi
Set-Alias wisp Generate-Srt
Set-Alias rgf Ripgrep-Find-Files
Set-Alias spa SystemPropertiesAdvanced
Set-Alias envs Open-Environment-Variables
Set-Alias optv Optimize-VHD
Set-Alias fgrep Fzf-Ripgrep
Set-Alias vscnvi Vscode-Nvim
Set-Alias csc CS-Check-All
Set-Alias csup CS-Update
Set-Alias csg CS-Lazygit

