$BOLD = "`e[1m" ; $TAIL  = "`e[0m" ; $WHITE  = "`e[37m"
$RED  = "`e[31m"; $GREEN = "`e[32m"; $YELLOW = "`e[33m"; $CYAN = "`e[36m"

function Write-Line     { param([string]$msg) Write-Host "$WHITE$msg$TAIL" }
function Write-Info     { param([string]$msg) if ($global:verbose) { Write-Line "$CYAN$msg" } }
function Write-Bold     { param([string]$msg) Write-Line "$BOLD$msg" }
function Write-Success  { param([string]$msg) Write-Bold "$GREEN$msg ✔" }
function Write-WarnMsg  { param([string]$msg) Write-Bold "$YELLOW$msg" }
function Write-ErrorMsg { param([string]$msg) Write-Bold "$RED$msg" }

function Test-HasCommand { param([string]$cmd)   return (Get-Command $cmd).length -gt 0 }
function Test-HasDir     { param([string]$dir)   return [System.IO.Path]::Exists($dir)  }
function Test-HasFile    { param([string]$file)  return [System.IO.File]::Exists($file) }

function Test-FileSame {
    param(
        [string]$file1,
        [string]$file2
    )
    return (Get-FileHash $file1).hash -eq (Get-FileHash $file2).hash
}

function Invoke-EnsureDir {
    param(
        [string]$dir
    )
    if (! (Test-HasDir $dir)) {
        New-Item -ItemType "directory" -Path $dir | Out-Null
    }
}

function Get-ScoopRoot {
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-ErrorMsg "Error: scoop not found."
        exit 1
    }
    return scoop config root_path
}

function Read-InputKey {
    param(
        [string]$message
    )
    Write-Host -NoNewline "$message"
    $user_input = [Console]::ReadKey()
    Write-Host
    return $user_input.Key
}

function Remove-Globals {
    Remove-Variable -Name verbose -Scope Global -Force
}

