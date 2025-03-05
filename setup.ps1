$DIR = Get-Item $PSCommandPath | Select-Object -ExpandProperty Target | Split-Path -Parent
if (! $DIR) { $DIR = $PSScriptRoot }

Import-Module (Join-Path $DIR "modules\util.psm1") -Scope Local -Force

$global:verbose = $false
$script:no_error = $true

function Show-Usage {
    Write-Bold "Usage:"
    Write-Line "  setup.ps1 [options]"
    Write-Line
    Write-Bold "Options:"
    Write-Line "  -h, --help       Display help"
    Write-Line "  -v, --verbose    Show detailed information"
}

function Invoke-CmdPaser {
    if (-not $args -or -not $args.Split) { return }

    foreach ($arg in $args.Split(" ")) {
        switch -Regex ($arg) {
            "^((-?h)|(-?-help))$"     { Show-Usage; exit 0 }
            "^((-?v)|(-?-verbose))$"  { $global:verbose = $true }
            default { Write-ErrorMsg "Error: Invalid option '$arg'"; Show-Usage; exit 1 }
        }
    }
}

function Invoke-CheckDependencies {
    $dependencies = @(
        "git"
    )

    foreach ($dependency in $dependencies) {
        if (! (Test-HasCommand $dependency)) {
            Write-ErrorMsg "Error: $dependency not found."
            $script:no_error = $false
        }
    }

    if (! $script:no_error) {
        Write-WarnMsg "Please install the required commands first."
        exit 1
    }
}

function Invoke-DownloadFromUrl {
    param(
        [string]$url,
        [string]$output = ""
    )

    if (! $output) {
        $output = (Split-Path $url -Leaf)
    }

    Invoke-EnsureDir (Split-Path $output)
    Invoke-ExistAndBackup $output

    $web_client = New-Object System.Net.WebClient
    try {
        $web_client.DownloadFile($url, $output)
    } catch {
        Write-ErrorMsg $_.Exception.Message
        Write-ErrorMsg "Error: Failed to download $url."
        return $false
    }
    return $true
}

function Write-InstallingMsg {
    param(
        [string]$package
    )
    Write-Line "Installing $package..."
}

function Write-InstalledMsg {
    param(
        [string]$package
    )
    Write-Info "$package is already installed."
}

function Test-NotInstalledInPath {
    param(
        [string]$dir,
        [string]$package
    )
    if (Test-HasDir $dir) {
        Write-InstalledMsg $package
        return $false
    } else {
        Write-InstallingMsg $package
        return $true
    }
}

function Test-NotInstalledFile {
    param(
        [string]$file,
        [string]$package
    )
    if (Test-HasFile -file $file) {
        Write-InstalledMsg $package
        return $false
    } else {
        Write-InstallingMsg $package
        return $true
    }
}

function Trace-InstallStatus {
    param(
        [bool]$status,
        [string]$package
    )
    if ($status) {
        Write-Success "$package has been installed."
    } else {
        Write-ErrorMsg "Error: Failed to install $package."
        $script:no_error = $false
    }
}

function Install-VimPlug {
    $vim_plug = "$HOME\AppData\Local\nvim-data\site\autoload\plug.vim"
    if (Test-NotInstalledFile -file $vim_plug -package "Vim-Plug") {
        $result = Invoke-DownloadFromUrl `
            -url "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" `
            -output $vim_plug
        Trace-InstallStatus -status $result -package "Vim-Plug"
    }
}

function Install-VifmCustom {
    if (! (Test-HasCommand vifm)) {
        warning "Warning: Vifm is not installed, skip installing Vifm custom."
        $script:no_error = $false
        return
    }

    $vifm_config_home = "$HOME\AppData\Roaming\Vifm"
    if (! (Test-HasDir $vifm_config_home)) {
        Write-Info "Generating original vifm configuration..."
        vifm +q
    }

    # vifm colors
    if (Test-NotInstalledFile -file "$vifm_config_home\colors\solarized-dark.vifm" -package "Vifm colorschemes") {
        Invoke-ExistAndBackup "$vifm_config_home\colors"
        git clone https://github.com/vifm/vifm-colors "$vifm_config_home\colors"
        Trace-InstallStatus -status $? -package "Vifm colorschemes"
    }
    # vifm-favicons
    if (Test-NotInstalledFile -file "$vifm_config_home\plugged\favicons.vifm" -package "Vifm devicons") {
        $result = Invoke-DownloadFromUrl `
            -url "https://raw.githubusercontent.com/cirala/vifm_devicons/master/favicons.vifm" `
            -output "$vifm_config_home\plugged\favicons.vifm"
        Trace-InstallStatus -status $result -package "Vifm devicons"
    }
}

function Install-YaziPackage {
    if (! (Test-HasCommand yazi)) {
        Write-WarnMsg "Warning: Yazi is not installed, skip installing Yazi package."
        $script:no_error = $false
        return
    }

    if (! (Test-HasCommand ya)) {
        Write-WarnMsg "Warning: Yazi package manager 'ya' command not found, skip installing Yazi package."
        $script:no_error = $false
        return
    }

    $yazi_config_home = "$HOME\AppData\Roaming\yazi\config"

    # yazi theme
    if (Test-NotInstalledFile -file "$yazi_config_home\flavors\catppuccin-mocha.yazi\flavor.toml" -package "Yazi theme") {
        ya pack -a yazi-rs/flavors:catppuccin-mocha
        Trace-InstallStatus -status $? -package "Yazi flavor catppuccin-mocha"
    }

    # yazi plugins
    if (Test-NotInstalledFile -file "$yazi_config_home\plugins\smart-enter.yazi\main.lua" -package "Yazi plugin smart-enter") {
        ya pack -a yazi-rs/plugins:smart-enter
        Trace-InstallStatus -status $? -package "Yazi plugin smart-enter"
    }
    if (Test-NotInstalledFile -file "$yazi_config_home\plugins\git.yazi\main.lua" -package "Yazi plugin git") {
        ya pack -a yazi-rs/plugins:git
        Trace-InstallStatus -status $? -package "Yazi plugin git"
    }
    if (Test-NotInstalledFile -file "$yazi_config_home\plugins\mediainfo.yazi\main.lua" -package "Yazi plugin mediainfo") {
        ya pack -a boydaihungst/mediainfo
        Trace-InstallStatus -status $? -package "Yazi plugin mediainfo"
    }
}

function Invoke-CreateSymlink {
    param(
        [string]$src,
        [string]$dest
    )

    if (Test-HasFile -file $dest) {
        if ((Get-Item $dest).LinkType -eq "SymbolicLink" -and (Get-Item $dest).Target -eq $src) {
            Write-Info "$dest is already linked."
            return
        } else {
            Write-WarnMsg "Warning: $dest exists, but not linked to $src."
            $script:no_error = $false
            return
        }
    } else {
        Invoke-EnsureDir (Split-Path $dest)
        New-Item -ItemType SymbolicLink -Path $dest -Value $src | Out-Null
        Write-Success "Linked $dest to $src."
    }
}

function Invoke-LinkFiles {
    $vimrc = "$HOME\_vimrc"
    if (! (Test-HasFile -file $vimrc)) {
        Write-Info "$vimrc not found."
        Copy-Item "$DIR\.vimrc" $vimrc
        Write-Success "Copied $DIR\.vimrc to $vimrc."
    }

    $files = @(
        @("$vimrc", "$HOME\AppData\Local\nvim\init.vim"),
        @("$DIR\check_consistency.ps1", "$HOME\.local\bin\check_consistency.ps1")
    )

    foreach ($file in $files) {
        Invoke-CreateSymlink -src $file[0] -dest $file[1]
    }
}

function Invoke-InstallAll {
    Install-VimPlug
    Install-VifmCustom
    Install-YaziPackage
    Invoke-LinkFiles

    if ($script:no_error) {
        Write-Success "All dependencies have been installed."
    }
}

function Invoke-Main {
    Invoke-CmdPaser $args
    Invoke-CheckDependencies
    Invoke-InstallAll
    Remove-Globals
}

Invoke-Main $args
