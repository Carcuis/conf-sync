$DIR = Split-Path -Parent $PSScriptRoot

$BOLD = "`e[1m" ; $TAIL  = "`e[0m" ; $WHITE  = "`e[37m"
$RED  = "`e[31m"; $GREEN = "`e[32m"; $YELLOW = "`e[33m"; $CYAN = "`e[36m"

function Write-Line     { param([string]$msg) Write-Host "$WHITE$msg$TAIL" }
function Write-Info     { param([string]$msg) if ($global:verbose) { Write-Line "$CYAN$msg" } }
function Write-Bold     { param([string]$msg) Write-Line "$BOLD$msg" }
function Write-Success  { param([string]$msg) Write-Bold "$GREEN$msg ✔" }
function Write-WarnMsg  { param([string]$msg) Write-Bold "$YELLOW$msg" }
function Write-ErrorMsg { param([string]$msg) Write-Bold "$RED$msg" }

function Test-HasCommand { param([string]$cmd)   return (Get-Command $cmd -ErrorAction SilentlyContinue).length -gt 0 }
function Test-HasDir     { param([string]$dir)   return [System.IO.Path]::Exists($dir)  }
function Test-HasFile    { param([string]$file)  return [System.IO.File]::Exists($file) }

function Test-FileSame {
    param(
        [string]$file1,
        [string]$file2
    )
    return (Get-FileHash $file1).hash -eq (Get-FileHash $file2).hash
}

function New-DirIfMissing {
    param(
        [string]$dir
    )
    if (! (Test-HasDir $dir)) {
        New-Item -ItemType "directory" -Path $dir | Out-Null
    }
}

function Backup-ExistingItem {
    param(
        [string]$src
    )
    if (-not (Test-HasFile $src) -and -not (Test-HasDir $src)) {
        return
    }

    $backup_dir = Join-Path -Path $DIR -ChildPath "backup"
    New-DirIfMissing $backup_dir

    $backup_file = Join-Path -Path $backup_dir -ChildPath "$(Split-Path -Leaf $src).$(Get-Date -Format 'yyMMdd_HHmmss')"
    Move-Item -Path $src -Destination $backup_file -Force
    if ($?) {
        Write-Info "Backuped '$src' to '$backup_file'."
    } else {
        Write-ErrorMsg "Error: Failed to backup '$src' to '$backup_file'."
    }
}

function Test-SystemCompatibility {
    if ([System.Environment]::OSVersion.Platform -ne "Win32NT") {
        Write-ErrorMsg "Error: This script can only run on Windows systems."
        exit 1
    }
}

function Get-ScoopRoot {
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        return scoop config root_path
    }
    $dir = "D:\dev\scoop"
    Write-Info "Scoop is not installed. Fallback scoop_root to $dir."
    return $dir
}

function Read-UserInputKey {
    param(
        [string]$message
    )
    Write-Host -NoNewline "$message"
    $user_input = [Console]::ReadKey()
    Write-Host
    return $user_input.Key
}

function Remove-ScriptVariables {
    Remove-Variable -Name verbose -Scope Global -Force
}
