# ================================
# Profile Manager Module
# ================================

$ProfilesPath = "$PSScriptRoot\..\Profiles"

function Save-Profile {
    param([string]$ProfileName, [hashtable]$Settings)
    New-Item -ItemType Directory -Force -Path $ProfilesPath | Out-Null
    $Settings | ConvertTo-Json -Depth 5 | Out-File "$ProfilesPath\$ProfileName.json" -Encoding UTF8
    Write-Host "Profile '$ProfileName' saved." -ForegroundColor Green
}

function Load-Profile {
    param([string]$ProfileName)
    $file = "$ProfilesPath\$ProfileName.json"
    if (Test-Path $file) {
        return (Get-Content $file | ConvertFrom-Json)
    } else {
        Write-Host "Profile '$ProfileName' not found!" -ForegroundColor Red
    }
}

function List-Profiles {
    Write-Host "Available Profiles:" -ForegroundColor Yellow
    Get-ChildItem "$ProfilesPath\*.json" | ForEach-Object {
        Write-Host "  - $($_.BaseName)"
    }
}

function Delete-Profile {
    param([string]$ProfileName)
    $file = "$ProfilesPath\$ProfileName.json"
    if (Test-Path $file) {
        Remove-Item $file
        Write-Host "Profile '$ProfileName' deleted." -ForegroundColor Red
    } else {
        Write-Host "Profile not found!" -ForegroundColor Red
    }
}