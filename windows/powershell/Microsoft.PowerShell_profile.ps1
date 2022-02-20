Set-PoshPrompt -Theme cui_theme

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
function SetProxyOn { $env:ALL_PROXY="socks5://127.0.0.1:10808" }
function SetProxyOff { $env:HTTP_PROXY="" }
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
Set-Alias proxy SetProxyOn
Set-Alias unproxy SetProxyOff
Set-Alias oneplus8 SshToOneplus8pro
Set-Alias lg lazygit
Set-Alias ipy ipython
