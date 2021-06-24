$psprofile_remote = ".\windows\powershell\Microsoft.PowerShell_profile.ps1"
$psprofile_local = "$profile"

$vimrc_remote = ".vimrc"
$vimrc_local = "$home\_vimrc"

$psprofile_sync_status = ((Get-FileHash $psprofile_remote).hash) -eq ((Get-FileHash $psprofile_local).hash)
$vimrc_sync_status = ((Get-FileHash $vimrc_remote).hash) -eq ((Get-FileHash $vimrc_local).hash)

$hasNvim = $false
$hasVim = $false
If ((Get-Command nvim).length -gt 0)
{
    $hasNvim = $true
    $edit_tool = "nvim -d"
} ElseIf ((Get-Command vim).length -gt 0)
{
    $hasVim = $true
    $edit_tool = "vimdiff"
} Else
{
    Write-Error "No vim or neovim found on your device.`nAborting..."
    exit
}

Function DiffFunc
{
    param($file1, $file2)
    if ($hasNvim)
    {
        nvim -d $file1 $file2
    } ElseIf ($hasVim)
    {
        vimdiff $file1 $file2
    }
}

$check_status = 0

If ($psprofile_sync_status -and $vimrc_sync_status)
{
    Write-Host "All files are the same.✔ `nNothing to do." -ForegroundColor green
    $check_status = 1
} Else
{
    If (-not $psprofile_sync_status)
    {
        Write-Host "PsProfile unsynchronized. Edit with $edit_tool ? [Y/n]"
        $user_input = [Console]::ReadKey('?')
        If ($user_input.Key -eq "Y" -or $user_input.Key -eq "Enter")
        {
            DiffFunc -file1 "$psprofile_remote" -file2 "$psprofile_local"
            $psprofile_sync_status = ((Get-FileHash $psprofile_remote).hash) -eq ((Get-FileHash $psprofile_local).hash)
            If ($psprofile_sync_status)
            {
                Write-Host "PsProfile is now synced."
            } Else
            {
                Write-Host "PsProfile is still unsynchronized."
                Write-Host "--Use `" $edit_tool $psprofile_remote $psprofile_local `" later"
                Write-Host "--or try to rerun this wizard"
            }
        } Else
        {
            Write-Host "PsProfile is still unsynchronized. Aborting."
        }
    } Else
    {
        Write-Host "PsProfile is already synced."
    }

    If (-not $vimrc_sync_status)
    {
        Write-Host "Vimrc unsynchronized. Edit with $edit_tool ? [Y/n]"
        $user_input = [Console]::ReadKey('?')
        If ($user_input.Key -eq "Y" -or $user_input.Key -eq "Enter")
        {
            DiffFunc -file1 "$vimrc_remote" -file2 "$vimrc_local"
            $vimrc_sync_status = ((Get-FileHash $vimrc_remote).hash) -eq ((Get-FileHash $vimrc_local).hash)
            If ($vimrc_sync_status)
            {
                Write-Host "Vimrc is now synced."
            } Else
            {
                Write-Host "Vimrc still unsynchronized."
                Write-Host "--Use `" $edit_tool $vimrc_remote $vimrc_local `" later"
                Write-Host "--or try to rerun this wizard"
            }
        } Else
        {
            Write-Host "Vimrc still unsynchronized. Aborting."
        }
    }
}

If ($psprofile_sync_status -and $vimrc_sync_status -and ($check_status -eq 0))
{
    Write-Host "All files are synchronized now.✔ " -ForegroundColor green
}
