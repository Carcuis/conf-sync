Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$true
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function DeleteCharOrExit

function EditFile
{
    param($file)
    if ((Get-Command nvim).length -gt 0) {
        nvim $file
    } elseif ((Get-Command vim).length -gt 0) {
        vim $file
    } elseif ((Get-Command code).length -gt 0) {
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
function GoUpTwo { Set-Location ../.. }
function GoUpThree { Set-Location ../../.. }
function GoUpFour { Set-Location ../../../.. }
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
    $env:ALL_PROXY = "http://127.0.0.1:10809"
    $env:HTTP_PROXY = "http://127.0.0.1:10809"
    $env:HTTPS_PROXY = "http://127.0.0.1:10809"
}
function SetProxyOff {
    $env:ALL_PROXY = ""
    $env:HTTP_PROXY = ""
    $env:HTTPS_PROXY = ""
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
function Create-Link($target, $link) {
    New-Item -ItemType SymbolicLink -Path $link -Value $target
}
function Move-And-Create-Link($target, $link) {
    if ( -not (Test-Path $target)) {
        Write-Error "Error: '$target' does not exist."
        return
    }
    $target_is_file = Test-Path -PathType Leaf $target
    $target_basename = Split-Path $target -Leaf

    $link_exists = Test-Path $link
    $link_is_file = $link_exists -and (Test-Path -PathType Leaf $link)
    $link_is_dir = $link_exists -and (Test-Path -PathType Container $link)
    $link_parent_dir = Split-Path $link -Parent
    $link_parent_exists = $link_exists -or (Test-Path $link_parent_dir -PathType Container)
    if ( -not $link_parent_exists) {
        Write-Error "Error: '$link_parent_dir' is not a directory or does not exist."
        return
    }

    if ($target_is_file) {
        if ($link_is_file) {
            Write-Error "Error: '$link' already exists."
            return
        }
        if ($link_is_dir) {
            Move-Item $target $link
            Create-Link (Join-Path $link $target_basename) $target
        } else { # $link is a new file name
            Move-Item $target $link
            Create-Link $link $target
        }
    } else { # $target is a directory
        if ($link_is_file) {
            Write-Error "Error: '$link' is a existing file, cannot move."
            return
        }
        if ($link_is_dir) {
            if (Test-Path (Join-Path $link $target_basename)) {
                Write-Error "Error: A file or directory named '$target_basename' already exists in $link ."
                return
            }
            Move-Item $target $link
            Create-Link (Join-Path $link $target_basename) $target
        } else { # $link does not exist
            Move-Item $target $link
            Create-Link $link $target
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

Set-Alias .. GoUpOne
Set-Alias ... GoUpTwo
Set-Alias .... GoUpThree
Set-Alias ..... GoUpFour
Set-Alias al ListAll
Set-Alias la ListAll
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
Set-Alias ipy ipython
Set-Alias pp ptpython
Set-Alias cdhk conda-hook
Set-Alias ln Create-Link
Set-Alias mvx Move-And-Create-Link
Set-Alias md5sum Sum-MD5
Set-Alias sha256sum Sum-SHA256

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
