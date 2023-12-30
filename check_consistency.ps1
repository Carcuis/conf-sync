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
    name = "coc-settings.json"
    remote = "$PSScriptRoot\.config\nvim\coc-settings.json"
    local = "$home\AppData\Local\nvim\coc-settings.json"
}
$ptpython = @{
    name = "PtPython config.py"
    remote = "$PSScriptRoot\.config\ptpython\config.py"
    local = "$home\AppData\Local\prompt_toolkit\ptpython\config.py"
}
$ideavimrc = @{
    name = "ideavimrc"
    remote = "$PSScriptRoot\dot_files\.ideavimrc"
    local = "$home\.ideavimrc"
}
$lazygit = @{
    name = "lazygit config.yml"
    remote = "$PSScriptRoot\.config\lazygit\config.yml"
    local = "$home\AppData\Roaming\lazygit\config.yml"
}
$git_config = @{
    name = "Globle git config"
    remote = "$PSScriptRoot\dot_files\.gitconfig"
    local = "$home\.gitconfig"
}
$file_list = @(
    $psprofile
    $vimrc
)
$extra_file_list = @(
    $coc_settings
    $ptpython
    $ideavimrc
    $lazygit
    $git_config
)

function CmdParser {
    if ($args -match "^-?a$") {
        $script:file_list = $file_list + $extra_file_list
    }
}

function RunDiffAll {
    foreach ($file in $file_list) {
        if (! [System.IO.File]::Exists($file.local)) {
            return $false
        }

        if ((Get-FileHash $file.remote).hash -ne (Get-FileHash $file.local).hash) {
            return $false
        }
    }
    return $true
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
        Write-Host "All files are the same.✔ `nNothing to do." -ForegroundColor Green
        exit
    }

    foreach ($file in $file_list) {
        if (! [System.IO.File]::Exists($file.local)) {
            $file_local_dir = Split-Path $file.local
            Write-Host "$($file.name) not found, create a copy to $($file.local) ? [Y/n] "
            $user_input = [Console]::ReadKey('?')
            if ($user_input.Key -eq "Y" -or $user_input.Key -eq "Enter") {
                if (! [System.IO.Path]::Exists($file_local_dir)) {
                    Write-Host "$file_local_dir not found, creating..."
                    New-Item -ItemType "directory" -Path $file_local_dir
                }
                Copy-Item -Path $file.remote -Destination $file.local
                Write-Host "Copied ``$($file.remote)`` to ``$($file.local)``.✔" -ForegroundColor Green
            } else {
                Write-Host "Abort." -ForegroundColor Yellow
            }
            continue
        }

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
