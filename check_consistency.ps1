$psprofile_remote = ".\windows\powershell\Microsoft.PowerShell_profile.ps1"
$psprofile_local = "$profile"

$vimrc_remote = ".vimrc"
$vimrc_local = "~\_vimrc"

$psprofile_sync_status = ((Get-FileHash $psprofile_remote).hash) -eq ((Get-FileHash $psprofile_local).hash)
$vimrc_sync_status = ((Get-FileHash $vimrc_remote).hash) -eq ((Get-FileHash $vimrc_local).hash)

$check_status = 0

If ($psprofile_sync_status -and $vimrc_sync_status)
{
    Write-Host "All files are the same.✔ `nNothing to do." -ForegroundColor green
    $check_status = 1
} Else
{
    If (-not $psprofile_sync_status)
    {
        Write-Host "PsProfile unsynchronized. Edit in vimdiff? [Y/n]"
        $user_input = [Console]::ReadKey('?')
        If ($user_input.Key -eq "Y" -or $user_input.Key -eq "Enter")
        {
            vimdiff $psprofile_remote $psprofile_local
            $psprofile_sync_status = ((Get-FileHash $psprofile_remote).hash) -eq ((Get-FileHash $psprofile_local).hash)
            If ($psprofile_sync_status)
            {
                Write-Host "PsProfile is now synced."
            } Else
            {
                Write-Host "PsProfile is still unsynchronized."
                Write-Host "--Use `" vimdiff $psprofile_remote $psprofile_local `" later"
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
        Write-Host "Vimrc unsynchronized. Edit in vimdiff? [Y/n]"
        $user_input = [Console]::ReadKey('?')
        If ($user_input.Key -eq "Y" -or $user_input.Key -eq "Enter")
        {
            vimdiff $vimrc_remote $vimrc_local
            $vimrc_sync_status = ((Get-FileHash $vimrc_remote).hash) -eq ((Get-FileHash $vimrc_local).hash)
            If ($vimrc_sync_status)
            {
                Write-Host "Vimrc is now synced."
            } Else
            {
                Write-Host "Vimrc still unsynchronized."
                Write-Host "--Use `" vimdiff $vimrc_remote $vimrc_local `" later"
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
