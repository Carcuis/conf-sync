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

function Invoke-ArgParser {
    if (-not $args -or -not $args.Split) { return }

    foreach ($arg in $args.Split(" ")) {
        switch -Regex ($arg) {
            "^((-?h)|(-?-help))$"     { Show-Usage; exit 0 }
            "^((-?v)|(-?-verbose))$"  { $global:verbose = $true }
            default { Write-ErrorMsg "Error: Invalid option '$arg'"; Show-Usage; exit 1 }
        }
    }
}

function Test-Dependencies {
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

    New-DirIfMissing (Split-Path $output)
    Backup-ExistingItem $output

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

function Test-DirNotInstalled {
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

function Test-FileNotInstalled {
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

function Write-InstallStatus {
    param(
        [bool]$status,
        [string]$content,
        [string[]]$prefix = @("Successfully installed", "Failed to install"),
        [string[]]$message = @("success", "failure")
    )
    if ($status) {
        if ($content) {
            Write-Success "$($prefix[0]) $content."
        } else {
            Write-Success "$($message[0])"
        }
    } else {
        if ($content) {
            Write-ErrorMsg "Error: $($prefix[1]) $content."
        } else {
            Write-ErrorMsg "Error: $($message[1])"
        }
        $script:no_error = $false
    }
}

function Install-VimPlug {
    $vim_plug = "$HOME\AppData\Local\nvim-data\site\autoload\plug.vim"
    if (Test-FileNotInstalled -file $vim_plug -package "Vim-Plug") {
        $result = Invoke-DownloadFromUrl `
            -url "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" `
            -output $vim_plug
        Write-InstallStatus -status $result -content "Vim-Plug"
    }
}

function Install-VscLazyNvim {
    $lazy_nvim = "$HOME\AppData\Local\vscnvim-data\lazy\lazy.nvim"
    $lazy_repo = "https://github.com/folke/lazy.nvim.git"
    if (Test-DirNotInstalled -dir $lazy_nvim -package "VSCode Neovim Lazy.nvim") {
        git clone --filter=blob:none --branch=stable $lazy_repo $lazy_nvim
        Write-InstallStatus -status $? -content "VSCode Neovim Lazy.nvim"
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
    if (Test-FileNotInstalled -file "$vifm_config_home\colors\solarized-dark.vifm" -package "Vifm colorschemes") {
        Backup-ExistingItem "$vifm_config_home\colors"
        git clone https://github.com/vifm/vifm-colors "$vifm_config_home\colors"
        Write-InstallStatus -status $? -content "Vifm colorschemes"
    }
    # vifm-favicons
    if (Test-FileNotInstalled -file "$vifm_config_home\plugged\favicons.vifm" -package "Vifm devicons") {
        $result = Invoke-DownloadFromUrl `
            -url "https://raw.githubusercontent.com/cirala/vifm_devicons/master/favicons.vifm" `
            -output "$vifm_config_home\plugged\favicons.vifm"
        Write-InstallStatus -status $result -content "Vifm devicons"
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
    if (Test-FileNotInstalled -file "$yazi_config_home\flavors\catppuccin-mocha.yazi\flavor.toml" -package "Yazi theme") {
        ya pack -a yazi-rs/flavors:catppuccin-mocha
        Write-InstallStatus -status $? -content "Yazi flavor catppuccin-mocha"
    }

    # yazi plugins
    if (Test-FileNotInstalled -file "$yazi_config_home\plugins\smart-enter.yazi\main.lua" -package "Yazi plugin smart-enter") {
        ya pack -a yazi-rs/plugins:smart-enter
        Write-InstallStatus -status $? -content "Yazi plugin smart-enter"
    }
    if (Test-FileNotInstalled -file "$yazi_config_home\plugins\git.yazi\main.lua" -package "Yazi plugin git") {
        ya pack -a yazi-rs/plugins:git
        Write-InstallStatus -status $? -content "Yazi plugin git"
    }
    if (Test-FileNotInstalled -file "$yazi_config_home\plugins\mediainfo.yazi\main.lua" -package "Yazi plugin mediainfo") {
        ya pack -a boydaihungst/mediainfo
        Write-InstallStatus -status $? -content "Yazi plugin mediainfo"
    }
}

function New-Symlink {
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
        New-DirIfMissing (Split-Path $dest)
        New-Item -ItemType SymbolicLink -Path $dest -Value $src | Out-Null
        Write-InstallStatus -status $? -content "$dest to $src" -prefix @("Linked", "Failed to link")
    }
}

function Install-LinkFiles {
    $vimrc = "$HOME\_vimrc"
    if (! (Test-HasFile -file $vimrc)) {
        Write-Info "$vimrc not found."
        Copy-Item "$DIR\.vimrc" $vimrc
        Write-InstallStatus -status $? -content "$DIR\.vimrc to $vimrc" -prefix @("Copied", "Failed to copy")
    }

    $links = @{
        "$vimrc" = "$HOME\AppData\Local\nvim\init.vim"
        "$DIR\check_consistency.ps1" = "$HOME\.local\bin\check_consistency.ps1"
    }

    foreach ($link in $links.GetEnumerator()) {
        New-Symlink -src $link.Key -dest $link.Value
    }
}

function Install-All {
    Install-VimPlug
    Install-VscLazyNvim
    Install-VifmCustom
    Install-YaziPackage
    Install-LinkFiles

    if ($script:no_error) {
        Write-Success "All dependencies have been installed."
    }
}

function Start-MainProcess {
    Test-SystemCompatibility
    Invoke-ArgParser $args
    Test-Dependencies
    Install-All
    Remove-ScriptVariables
}

Start-MainProcess $args
