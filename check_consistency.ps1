$psprofile = @{
    name = "PSProfile"
    remote = "$PSScriptRoot\windows\powershell\Microsoft.PowerShell_profile.ps1"
    local = "$home\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
}
$vimrc = @{
    name = "vimrc"
    remote = "$PSScriptRoot\.vimrc"
    local = "$home\_vimrc"
}
$coc_settings = @{
    name = "coc-settings"
    remote = "$PSScriptRoot\.config\nvim\coc-settings.json"
    local = "$home\AppData\Local\nvim\coc-settings.json"
}
$file_list = @(
    $psprofile
    $vimrc
)
$extra_file_list = @(
    $coc_settings
)

function CmdParser {
    if ($args -match "^-?a$") {
        $script:file_list = $file_list + $extra_file_list
    }
}

function RunDiffAll {
    $_all_synced = $true
    foreach ($file in $file_list) {
        if ((Get-FileHash $file.remote).hash -ne (Get-FileHash $file.local).hash) {
            $_all_synced = $false
        }
    }
    return $_all_synced
}

function CheckEditor {
    if ((Get-Command nvim).length -gt 0) {
        $_cmd = "nvim -d"
    } elseif ((Get-Command vim).length -gt 0) {
        $_cmd = "vimdiff"
    } else {
        Write-Error "No vim or neovim found on your device.`nAborting..."
        exit 1
    }
    return $_cmd
}

function DiffFunc {
    param($file1, $file2)
    if ($edit_cmd -eq "nvim -d")
    {
        nvim -d $file1 $file2
    } elseif ($edit_cmd -eq "vimdiff")
    {
        vimdiff $file1 $file2
    }
}

function RunEdit {
    if (RunDiffAll) {
        Write-Host "All files are the same.✔ `nNothing to do." -ForegroundColor green
        exit
    }
    foreach ($file in $file_list){
        if ((Get-FileHash $file.remote).hash -ne (Get-FileHash $file.local).hash) {
            Write-Host "$($file.name) unsynchronized. Edit with $edit_cmd ? [Y/n]"
            $user_input = [Console]::ReadKey('?')
            if ($user_input.Key -eq "Y" -or $user_input.Key -eq "Enter") {
                DiffFunc -file1 $file.remote -file2 $file.local
                if ((Get-FileHash $file.remote).hash -eq (Get-FileHash $file.local).hash) {
                    Write-Host "$($file.name) is now synced.✔" -ForegroundColor Green
                } else {
                    Write-Host "$($file.name) is still unsynchronized." -ForegroundColor Cyan
                    Write-Host "-- Use ``$edit_cmd $($file.remote) $($file.local)`` later," -ForegroundColor Cyan
                    Write-Host "-- or try to rerun this wizard." -ForegroundColor Cyan
                }
            } else {
                Write-Host "$($file.name) is still unsynchronized. Aborting." -ForegroundColor Yellow
            }
        } else {
            Write-Host "$($file.name) is already synced.✔" -ForegroundColor Green
        }
    }

    if (RunDiffAll) {
        Write-Host "All files are synchronized now.✔ " -ForegroundColor Green
    }
}

# main
CmdParser $args[0]
$edit_cmd = CheckEditor
RunEdit