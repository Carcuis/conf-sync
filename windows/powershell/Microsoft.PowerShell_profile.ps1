Set-PoshPrompt -Theme cui_theme

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function DeleteCharOrExit

Get-quote|lolcat

function GoUpOne { Set-Location .. }
function GoUpTwo { Set-Location ../.. }
function GoUpThree { Set-Location ../../.. }
function GoUpFour { Set-Location ../../../.. }
function OpenCwd { explorer.exe . }
function EditProfileWithVim { vim $profile }
function EditProfileWithGVim { gvim $profile }
function EditVimrc { vim "D:\Program Files\Vim\_vimrc" }
function OpenVifmInPwd { vifm_copy.exe . }
function ReloadProfile { . $profile }
function GetAdminPriv { Start-Process pwsh -Verb runAs }
function StartSshServiceInWsl { wsl -- sudo service ssh start }
function StopSshServiceInWsl { wsl -- sudo service ssh stop }
function SetProxyOn { $env:ALL_PROXY="socks5://127.0.0.1:10808" }
function SetProxyOff { $env:HTTP_PROXY="" }

Set-Alias .. GoUpOne
Set-Alias ... GoUpTwo
Set-Alias .... GoUpThree
Set-Alias ..... GoUpFour
Set-Alias al Get-ChildItemColorFormatWide
Set-Alias la Get-ChildItemColorFormatWide
Set-Alias ls Get-ChildItemColorFormatWide
Set-Alias ll Get-ChildItemColor
Set-Alias which Get-Command
Set-Alias o explorer.exe
Set-Alias o. OpenCwd
Set-Alias touch New-Item
Set-Alias vi vim
Set-Alias pwshc EditProfileWithVim
Set-Alias pwshcg EditProfileWithGVim
Set-Alias vimc EditVimrc
Set-Alias vifm OpenVifmInPwd
Set-Alias src ReloadProfile
Set-Alias su GetAdminPriv
Set-Alias sshon StartSshServiceInWSl
Set-Alias sshoff StopSshServiceInWSl
Set-Alias proxy SetProxyOn
Set-Alias unproxy SetProxyOff
