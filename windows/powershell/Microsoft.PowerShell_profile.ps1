oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/cui_theme.omp.json" | Invoke-Expression

$env:POSH_GIT_ENABLED = $true

Import-Module Terminal-Icons

Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function DeleteCharOrExit
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

Get-quote|lolcat

If ((Get-Command nvim).length -gt 0)
{
    $hasNvim = $true
} ElseIf ((Get-Command vim).length -gt 0)
{
    $hasVim = $true
} Else
{
    Write-Error "No vim or neovim found on your device.`nAborting..."
    exit
}

function EditFile
{
    param($file)
    if ($hasNvim)
    {
        nvim $file
    } ElseIf ($hasVim)
    {
        vim $file
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
function OpenVifmInPwd { vifm.exe . }
function ReloadProfile { & $profile }
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
function SshToOneplus8pro { ssh -p 8022 192.168.137.68 -i ~\.ssh\oneplus8 }

Remove-Item alias:\gl -Force
Remove-Item alias:\gp -Force

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
Set-Alias oneplus8 SshToOneplus8pro
Set-Alias lg lazygit
Set-Alias ipy ipython
Set-Alias pp ptpython
