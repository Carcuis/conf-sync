# ====================================================================
#   _____                  _         ___  _______           ____ __
#  / ___/__ ___________ __(_)__     / _ \/ __/ _ \_______  / _(_) /__
# / /__/ _ `/ __/ __/ // / (_-<    / ___/\ \/ ___/ __/ _ \/ _/ / / -_)
# \___/\_,_/_/  \__/\_,_/_/___/   /_/  /___/_/  /_/  \___/_//_/_/\__/
#
# ====================================================================

(Get-quote).TrimEnd() | cowsay -f moose -W 80 | lolcat

oh-my-posh init pwsh --config "$HOME\.config\ohmyposh\themes\cui_theme.omp.json" | Invoke-Expression

$env:EDITOR = "nvim"
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1

Import-Module -Name Terminal-Icons
Import-Module -Name CompletionPredictor
Import-Module -Name git-aliases-plus -DisableNameChecking
Import-Module -Name posh-git -arg 0,0,1
Import-Module -Name scoop-completion
Import-Module -Name WSLTabCompletion

$PSReadLineOption = @{
    EditMode = "Emacs"
    HistorySearchCursorMovesToEnd = $true
    PredictionSource = "HistoryAndPlugin"
    PredictionViewStyle = "ListView"
}
Set-PSReadLineOption @PSReadLineOption

$PSReadLineKeyHandler = @{
    Tab = "MenuComplete"
    UpArrow = "HistorySearchBackward"
    DownArrow = "HistorySearchForward"
    "Ctrl+LeftArrow" = "BackwardWord"
    "Ctrl+RightArrow" = "ForwardWord"
    "Ctrl+d" = "DeleteCharOrExit"
}
foreach ($key in $PSReadLineKeyHandler.GetEnumerator()) {
    Set-PSReadLineKeyHandler -Key $key.Key -Function $key.Value
}

$PsFzfOption = @{
    PSReadlineChordProvider = 'Ctrl+t'
    PSReadlineChordReverseHistory = 'Ctrl+r'
    PSReadlineChordSetLocation = 'Alt+c'
}
Set-PsFzfOption @PsFzfOption

# === util functions ===
function Test-HasCommand { param([string]$cmd)   return (Get-Command $cmd -ErrorAction SilentlyContinue).length -gt 0 }
function Test-HasDir     { param([string]$dir)   return [System.IO.Path]::Exists($dir)  }
function Test-HasFile    { param([string]$file)  return [System.IO.File]::Exists($file) }

# === edit files ===
function Start-EditFile
{
    param($file)
    if (Test-HasCommand nvim) {
        nvim $file
    } elseif (Test-HasCommand vim) {
        vim $file
    } elseif (Test-HasCommand gvim) {
        code $file
    } else {
        notepad $file
    }
}

function Edit-PSProfile { Start-EditFile $profile }
function Edit-Vimrc { Start-EditFile $HOME\_vimrc }
function Edit-CommandHistory { Start-EditFile (Get-PSReadLineOption).HistorySavePath }

function Edit-EnvironmentVariables {
    param (
        [switch] $sudo
    )
    if ($sudo) {
        Start-Process -Verb RunAs rundll32.exe "sysdm.cpl,EditEnvironmentVariables"
    } else {
        Start-Process rundll32.exe "sysdm.cpl,EditEnvironmentVariables"
    }
}

# === ls functions ===
function Invoke-ListChildAutoSize { Get-ChildItem | Format-Wide -AutoSize }
function Invoke-ListAllChildAutoSize { Get-ChildItem -Force | Format-Wide -AutoSize }
function Invoke-ListAllChild { Get-ChildItem -Force }

# === cd functions ===
function Set-LocationUpOne { Set-Location .. }
function Set-LocationUpTwo { Set-Location ..\.. }
function Set-LocationUpThree { Set-Location ..\..\.. }
function Set-LocationUpFour { Set-Location ..\..\..\.. }

# === open in cwd ===
function Start-ExplorerCwd { explorer . }
function Start-VifmCwd { vifm.exe . }

# === pwsh util functions ===
function Invoke-ReloadPSProfile { . $profile }
function Start-PwshAsAdmin { Start-Process pwsh -Verb runAs }

# === manage ssh in wsl (deprecated) ===
function Enable-SshServiceInWsl { wsl -- sudo service ssh start }
function Disable-SshServiceInWsl { wsl -- sudo service ssh stop }

# === network ===
function Enable-Proxy {
    $proxy_server = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings').ProxyServer
    $proxy_port = $proxy_server -split ':' | Select-Object -Last 1
    $env:ALL_PROXY = "http://$proxy_server"
    $env:HTTP_PROXY = "http://$proxy_server"
    $env:HTTPS_PROXY = "http://$proxy_server"
    $env:PROXY_PORT = $proxy_port
}

function Disable-Proxy {
    $env:ALL_PROXY = ""
    $env:HTTP_PROXY = ""
    $env:HTTPS_PROXY = ""
    $env:PROXY_PORT = ""
}

function Invoke-AutoSetProxy {
    $registry_key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    if ((Get-ItemProperty -Path $registry_key).ProxyEnable -eq 1) {
        Enable-Proxy
    }
} Invoke-AutoSetProxy

function Test-WebConnection {
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

# === python environment variables ===
function Test-CondaHooked {
    if ($env:CONDA_EXE) {
        return $true
    }
    return $false
}

function Test-HasVirtualEnv {
    if ($env:VIRTUAL_ENV) {
        return $true
    }
    return $false
}

function Test-HasCondaEnv{
    if ($env:CONDA_DEFAULT_ENV) {
        return $true
    }
    return $false
}

function Update-TerminalSizeValue {
<#
.SYNOPSIS
    Update environment variables with the current terminal size.

.DESCRIPTION
    Update the environment variables 'TERMINAL_WIDTH' and 'TERMINAL_HEIGHT' with the current terminal size.
    Update the environment variable 'OHMYPOSH_MAX_PATH_LENGTH' with the maximum path length that can be displayed.
#>
    $width = $Host.UI.RawUI.WindowSize.Width
    $height = $Host.UI.RawUI.WindowSize.Height
    $max_path_length = [Math]::Floor($width / 2)

    $cut_length = 0
    if (Test-HasVirtualEnv) {
        $venv_name = Split-Path -Parent $env:VIRTUAL_ENV | Split-Path -Leaf
        $cut_length += 13 + $venv_name.Length
    } elseif (Test-HasCondaEnv) {
        $conda_env_name = $env:CONDA_DEFAULT_ENV
        $cut_length += 15 + $conda_env_name.Length
    }
    if ((Get-GitDirectory).length -gt 0) {
        $cut_length += 15
    }
    if ($env:ALL_PROXY) {
        $cut_length += 4
    }
    $max_path_length -= $cut_length

    $spare_length = 70
    $max_path_length = [Math]::Min($max_path_length, $width - $cut_length - $spare_length)

    $env:TERMINAL_WIDTH = $width
    $env:TERMINAL_HEIGHT = $height
    $env:OHMYPOSH_MAX_PATH_LENGTH = $max_path_length
} Update-TerminalSizeValue
Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
    Update-TerminalSizeValue
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# === python environment list ===
function Get-CondaEnvs {
<#
.SYNOPSIS
    Get a list of conda environments from the 'environments.txt' file rather than using 'conda env list'.

.OUTPUTS
    [PSCustomObject[]] An array of objects containing the environment name and path.
#>
    $envs_file = "$HOME\.conda\environments.txt"
    if (! (Test-Path $envs_file)) {
        return @()
    }
    $envs = @()
    $base_paths = @()
    $lines = Get-Content $envs_file | Sort-Object
    foreach ($line in $lines) {
        if ($line -match "envs\\[^\\]+$") {
            # Extract environment name from path
            $env_name = $line -replace ".*envs\\", ""
            $envs += [PSCustomObject]@{ Name = $env_name; Path = $line }
        } else { # Base environment
            # If it's a symlink, check if the target is already in the list
            $resolved_path = Get-Item $line | Select-Object -ExpandProperty Target -ErrorAction SilentlyContinue
            if ($base_paths -contains $resolved_path) { continue }

            # Else, add it to the list
            $base_paths += $line
            $envs += [PSCustomObject]@{ Name = "base"; Path = $line }
        }
    }
    return $envs
}

function Get-VirtualEnvsCwd {
<#
.SYNOPSIS
    Get a list of virtual environments in the current directory.

.OUTPUTS
    [PSCustomObject[]] An array of objects containing the environment folder name and its Activate.ps1 path.
#>
    & fd -HI -tf --exact-depth 3 "^.*activate\.ps1$" 2>$null | ForEach-Object {
        $path = $_
        $name = Split-Path $path -Parent | Split-Path -Parent
        [PSCustomObject]@{ Name = $name; Path = $path }
    }
}

# === miniconda function ===
function Invoke-CondaHook {
    conda shell.powershell hook | Out-String | Where-Object {$_} | Invoke-Expression
}

function Test-HasCondaEnvName {
<#
.SYNOPSIS
    Check if a conda environment with the given name exists.

.PARAMETER name
    The name of the conda environment to check.

.OUTPUTS
    [bool] True if the conda environment exists, false otherwise.
#>
    param(
        [string] $name
    )
    if (Get-CondaEnvs | Where-Object { $_.Name -eq $name }) {
        return $true
    }
    return $false
}

# === creat/activate/deactivate python environments ===
function Invoke-MakePythonVenv {
    param(
        [string] $name = "venv"
    )
    if (! (Test-HasCommand python)) {
        Write-Error "Error: Cannot find 'python' command."
        return
    }
    python -m venv $name
    Write-Host "Created venv in '$name'"
    Invoke-ActivatePythonVenv -name $name
}

function Invoke-ActivatePythonVenv {
<#
.SYNOPSIS
    Activate a virtual environment (uv/venv/conda) by name or search for venv in the current directory.

.PARAMETER name
    The name of the virtual environment to activate. If not provided, searches for "venv" or ".venv" in the current directory.

.PARAMETER dir
    The directory to search for the virtual environment. Defaults to the current working directory.

.PARAMETER silent
    Suppresses output messages if specified.
#>
    param(
        [string] $name,
        [string] $dir = $PWD,
        [switch] $silent
    )

    function Write-Info { param([string]$msg) if (! $silent) { Write-Host $msg } }
    function Write-ErrorMsg { param([string]$msg) if (! $silent) { Write-Error $msg } }

    if (! $name) {
        $found = $false
        foreach ($_name in @("venv", ".venv")) {
            $activate_script = Join-Path -Path $dir -ChildPath "${_name}\Scripts\Activate.ps1"
            if (Test-HasFile $activate_script) {
                $found = $true
                . $activate_script
                Write-Info "Activated virtual environment '$_name'."
                break
            }
        }
        if (! $found) {
            Write-ErrorMsg "Error: Cannot find venv in $dir"
        }
    } else {
        $activate_script = Join-Path -Path $dir -ChildPath "${name}\Scripts\Activate.ps1"
        if (Test-HasFile $activate_script) {
            . $activate_script
            Write-Info "Activated virtual environment '$name'."
        } elseif (Test-HasCondaEnvName -name $name) {
            if (Test-HasVirtualEnv) {
                Invoke-DeactivatePythonVenv
            }
            $no_conda_before = $false
            if (! (Test-CondaHooked)) {
                $no_conda_before = $true
                Invoke-CondaHook
            }
            if ("$name" -eq "base" -and $no_conda_before) {
                Write-Info "Activated conda environment 'base'."
            } elseif ("$name" -eq $env:CONDA_DEFAULT_ENV) {
                Write-Info "Already activated conda environment '$name'."
            } else {
                if (Test-HasCondaEnv) {
                    conda deactivate
                }
                conda activate $name
                Write-Info "Activated conda environment '$name'."
            }
        } else {
            Write-ErrorMsg "Error: Cannot find virtual environment '$name'."
        }
    }
    Update-TerminalSizeValue
}
Register-ArgumentCompleter -CommandName Invoke-ActivatePythonVenv -ParameterName name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    (Get-CondaEnvs) + (Get-VirtualEnvsCwd) | Where-Object { $_.Name -like "$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Path)
    }
}

function Invoke-DeactivatePythonVenv {
<#
.SYNOPSIS
    Deactivate current virtual environment (uv/venv/conda).
#>
    if (Test-HasVirtualEnv) {
        if (Test-HasCommand deactivate) {
            deactivate
        } else {
            Write-Error "Error: Cannot find 'deactivate' command."
        }
    } elseif (Test-HasCondaEnv) {
        conda deactivate
    } else {
        Write-Error "Error: No virtual environment is activated."
    }
    Update-TerminalSizeValue
}

function Invoke-AutoActivatePythonVenv {
<#
.SYNOPSIS
    Automatically activate/deactivate virtual environment when changing directory.

.PARAMETER dir
    The directory to search for the virtual environment. Defaults to the current working directory.
#>
    param(
        [string] $dir
    )
    if (Test-HasVirtualEnv) {
        if ($dir -like "$(Split-Path -Path $env:VIRTUAL_ENV -Parent)*") {
            return
        } else {
            Invoke-DeactivatePythonVenv
        }
    }

    Invoke-ActivatePythonVenv -dir $dir -silent
}
(Get-Variable PWD).Attributes.Add($(New-Object ValidateScript { Invoke-AutoActivatePythonVenv $_; return $true }))

# === manage files ===
function Invoke-CreateLink() {
    param(
        [string] $target,
        [string] $link
    )
    if (! (Test-Path $target)) {
        Write-Error "Error: '$target' does not exist."
        return
    }
    $target = (Get-Item $target).FullName
    New-Item -ItemType SymbolicLink -Path $link -Value $target
}

function Invoke-MoveAndCreateLink() {
    param(
        [string] $target,
        [string] $dest
    )

    if (! $target -and ! $dest) {
        Write-Host "Move file or directory to a new location and create a link on the original location,"
        Write-Host "    pointing to the new location.`n"
        Write-Host "Usage: Invoke-MoveAndCreateLink [-target] <target> [-dest] <dest>`n"
        Write-Host "    -target: The file or directory to be moved. Should be absolute path."
        Write-Host "    -dest: The destination file or directory. Should be absolute path."
        return
    }

    if (! (Test-Path $target)) {
        Write-Error "Error: '$target' does not exist."
        return
    }

    if (! ([System.IO.Path]::IsPathRooted($target) -and [System.IO.Path]::IsPathRooted($dest))) {
        Write-Error "Error: Both target and dest should be absolute paths."
        return
    }

    $target_is_file = Test-HasFile $target
    $target_basename = Split-Path $target -Leaf

    $dest_is_file = Test-HasFile $dest
    $dest_is_dir = Test-HasDir $dest

    if ($target_is_file) {
        if ($dest_is_file) {
            Write-Error "Error: '$dest' already exists."
            return
        }
        if ($dest_is_dir) {
            Move-Item $target $dest
            Invoke-CreateLink (Join-Path $dest $target_basename) $target
        } else { # $dest is a new file name
            Move-Item $target $dest
            Invoke-CreateLink $dest $target
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
            Invoke-CreateLink (Join-Path $dest $target_basename) $target
        } else { # $dest does not exist
            Move-Item $target $dest
            Invoke-CreateLink $dest $target
        }
    }
}

function Remove-OldPSMuduleVersions {
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

# === calculate hash ===
function Get-MD5Sum()       { param([string] $file) Get-FileHash -Algorithm MD5 -Path $file }
function Get-SHA256Sum()    { param([string] $file) Get-FileHash -Algorithm SHA256 -Path $file }

# === Other functions ===
function Invoke-GenerateSrt {
    param (
        [string]$file,
        [string]$model,
        [string]$language = "en"
    )

    if (! $file) {
        Write-Host "Generate SRT file from video/audio file(s).`n"
        Write-Host "Usage: Invoke-GenerateSrt [-file] <file> [-model] <model> [-language] <language>`n"
        Write-Host "    -file: The video/audio file to be processed. Wildcards are supported.`n"
        Write-Host "    -model: The model to be used for processing. Default is auto-selected based on VRAM size.`n"
        Write-Host "    -language: The language of the audio. Default is 'en'.`n"
        return
    }

    $files = Get-Item $file -ErrorAction SilentlyContinue | Where-Object { $_.Extension -ne ".srt" }
    if ($null -eq $files) {
        Write-Error "Error: No video/audio files found."
        return
    }
    Write-Host "Total files: $(($files | Measure-Object).Count)"
    $files | ForEach-Object { Write-Host "$_" }
    Write-Host

    $vram = 0
    $gpuName = "Unknown"

    # Retrieve information about the active graphics card
    try {
        $nvidiaSmiOutput = nvidia-smi --query-gpu=memory.total --format=csv,noheader
        if ($null -ne $nvidiaSmiOutput) {
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

    if (! $model) {
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

    if (! (Test-HasCommand whisper)) {
        if (! (Test-HasCondaEnvName -name "whisper")) {
            Write-Error "Error: Cannot find 'whisper' conda env."
            return
        }

        Invoke-ActivatePythonVenv -name "whisper"
        Write-Host "Activated 'whisper' virtual environment.`n"

        if (! (Test-HasCommand whisper)) {
            Write-Error "Error: Cannot find 'whisper' command."
            return
        }
    }

    Write-Host "Using model '$model' for GPU '$gpuName' with $vram MB VRAM.`n"

    foreach ($file in $files) {
        Write-Host "`nProcessing file: $file`n"
        whisper --language $language --model $model -f srt $file
    }
}

function Search-FilesByRipgrep {
    param (
        [string]$pattern,
        [string]$glob = "!.git"
    )

    if (! (Test-HasCommand rg)) {
        Write-Error "Error: Cannot find 'rg' command."
        return
    }

    if (! $pattern) {
        Write-Host "Ripgrep find files with pattern in directory.`n"
        Write-Host "Usage: Search-FilesByRipgrep [-pattern] <pattern> [-glob] <pattern>`n"
        Write-Host "    -pattern: The pattern to search for."
        Write-Host "    -glob: The glob pattern of files to search. Default is '!git'."
        return
    }

    rg --files --hidden --sort-files --glob $glob | rg --pcre2 $pattern
}

function Optimize-VHD {
<#
.SYNOPSIS
    Optimize the size of a WSL vhdx file by running the 'compact' command using Diskpart.

.PARAMETER Path
    The path to the vhdx file to optimize. If not provided, the script will automatically search for all vhdx files in
    %LOCALAPPDATA%\Packages and prompt the user to select one.
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
    } elseif (-not (Test-HasFile $Path) -or -not ($Path -like "*.vhdx")) {
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

function Search-WordByFzf {
<#
.SYNOPSIS
    Use PSFzf to search words in files with ripgrep in the current directory.

.PARAMETER words
    The words to search for in files.
#>
    param (
        [string]$words = ""
    )
    if (! (Test-HasCommand Invoke-PsFzfRipgrep)) {
        Write-Error "Error: Cannot find 'Invoke-PsFzfRipgrep' command."
        return
    }
    Invoke-PsFzfRipgrep $words
}

function Start-VscodeNvim {
    if (! (Test-HasCommand nvim)) {
        Write-Error "Error: Cannot find 'nvim' command."
        return
    }
    pwsh -NoLogo -NoProfile -NonInteractive -Command {
        $env:NVIM_APPNAME="vscnvim"
        nvim @Args
    } -Arg $Args
}

# === conf-sync ===
function Get-CheckConsistencyPs1 {
    $script = "$HOME\.local\bin\check_consistency.ps1"
    if (! (Test-HasFile $script)) {
        Write-Error "Error: Cannot find '$script'."
        return
    }
    return $script
}

function Get-ConfSyncDir {
    if (! ($script = Get-CheckConsistencyPs1)) { return }
    return (Get-Item $script | Select-Object -ExpandProperty Target | Split-Path -Parent)
}

function Invoke-ConfSyncCheckAll {
    if (! ($script = Get-CheckConsistencyPs1)) { return }

    function Show-Usage {
        Write-Host "Usage:"
        Write-Host "  Invoke-ConfSyncCheckAll [options]"
        Write-Host
        Write-Host "Options:"
        Write-Host "  -f, --force-sync Force sync files"
        Write-Host "  -h, --help       Display help"
        Write-Host "  -s, --status     Show status of all files"
        Write-Host "  -v, --verbose    Show detailed information"
    }

    $params = "-a"
    foreach ($arg in $args) {
        switch -Regex ($arg) {
            "^((-?f)|(-?-force))$"    { $params += " -f"; continue }
            "^((-?h)|(-?-help))$"     { Show-Usage; return }
            "^((-?s)|(-?-status))$"   { $params += " -s"; continue }
            "^((-?v)|(-?-verbose))$"  { $params += " -v"; continue }
            default { Write-Error "Error: Invalid option '$arg'"; Show-Usage; return }
        }
    }
    & $script $params
}

function Invoke-ConfSyncUpdate {
    if (! ($script = Get-CheckConsistencyPs1)) { return }

    function Show-Usage {
        Write-Host "Usage:"
        Write-Host "  Invoke-ConfSyncUpdate [options]"
        Write-Host
        Write-Host "Options:"
        Write-Host "  -f, --force-sync Force sync files"
        Write-Host "  -h, --help       Display help"
        Write-Host "  -v, --verbose    Show detailed information"
    }

    $params = "-a"
    foreach ($arg in $args) {
        switch -Regex ($arg) {
            "^((-?f)|(-?-force))$"    { $params += " -f"; continue }
            "^((-?h)|(-?-help))$"     { Show-Usage; return }
            "^((-?v)|(-?-verbose))$"  { $params += " -v"; continue }
            default { Write-Error "Error: Invalid option '$arg'"; Show-Usage; return }
        }
    }

    if ((& $script "-a -s" 6>&1 | Out-String -NoNewline) -eq "Unsynchronized.") {
        Write-Host "`e[1;33mThere are inconsistent files.`nPlease run 'csc' to sync them first.`e[0m"
        return
    }

    $DIR = Get-ConfSyncDir
    if ((git -C $DIR status -u --porcelain).Length -ne 0) {
        Write-Host "`e[1;33mThere are uncommitted changes in the repository.`nPlease commit or stash them first.`e[0m"
        return
    }
    git -C $DIR pull --rebase
    git -C $DIR log --format="%C(blue)%h %C(green)(%ad) %C(white)%s" --date=format-local:'%b %e %H:%M' ORIG_HEAD..HEAD

    & $script $params
}

function Start-ConfSyncLazygit {
    if (! (Get-CheckConsistencyPs1)) { return }
    lazygit -p (Get-ConfSyncDir)
}

@{
    # builtin function aliases
    "which" = "Get-Command"
    "touch" = "New-Item"

    # command aliases
    "o" = "explorer"
    "spa" = "SystemPropertiesAdvanced"
    "vi" = "vim"
    "gvi" = "gvim"
    "nvi" = "nvim"
    "nvid" = "neovide"
    "gnvi" = "nvim-qt"
    "lg" = "lazygit"
    "lzd" = "lazydocker"
    "pp" = "ptpython"
    "ff" = "fastfetch"
    "of" = "onefetch"
    "yz" = "yazi"

    # edit files
    "pwshc" = "Edit-PSProfile"
    "vimc" = "Edit-Vimrc"
    "histc" = "Edit-CommandHistory"
    "envs" = "Edit-EnvironmentVariables"

    # ls functions
    "l" = "Get-ChildItem"
    "ls" = "Invoke-ListChildAutoSize"
    "al" = "Invoke-ListAllChildAutoSize"
    "la" = "Invoke-ListAllChildAutoSize"
    "ll" = "Invoke-ListAllChild"

    # cd functions
    ".." = "Set-LocationUpOne"
    "..." = "Set-LocationUpTwo"
    "...." = "Set-LocationUpThree"
    "....." = "Set-LocationUpFour"

    # open in cwd
    "o." = "Start-ExplorerCwd"
    "vif" = "Start-VifmCwd"
    "vifm" = "Start-VifmCwd"

    # pwsh util functions
    "src" = "Invoke-ReloadPSProfile"
    "su" = "Start-PwshAsAdmin"

    # network
    "px" = "Enable-Proxy"
    "upx" = "Disable-Proxy"
    "wd" = "Test-WebConnection"

    # miniconda function
    "cdhk" = "Invoke-CondaHook"

    # creat/activate/deactivate python environments
    "mkv" = "Invoke-MakePythonVenv"
    "vrun" = "Invoke-ActivatePythonVenv"
    "dac" = "Invoke-DeactivatePythonVenv"

    # manage files
    "ln" = "Invoke-CreateLink"
    "mvx" = "Invoke-MoveAndCreateLink"
    "psmclo" = "Remove-OldPSMuduleVersions"
    "rm-rf" = "Remove-ItemRecurseForce"

    # calculate hash
    "md5sum" = "Get-MD5Sum"
    "sha256sum" = "Get-SHA256Sum"

    # other functions
    "wisp" = "Invoke-GenerateSrt"
    "rgf" = "Search-FilesByRipgrep"
    "optv" = "Optimize-VHD"
    "fgrep" = "Search-WordByFzf"
    "vscnvi" = "Start-VscodeNvim"

    # conf-sync
    "csc" = "Invoke-ConfSyncCheckAll"
    "csup" = "Invoke-ConfSyncUpdate"
    "csg" = "Start-ConfSyncLazygit"

}.GetEnumerator() | ForEach-Object { Set-Alias -Name $_.Key -Value $_.Value }
