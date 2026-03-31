$ProfilesPath = "$PSScriptRoot\..\Profiles"

function Save-Profile {
    param([string]$ProfileName, [hashtable]$Settings)
    $Settings | ConvertTo-Json -Depth 5 | Out-File "$ProfilesPath\$ProfileName.json"
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
    Get-ChildItem "$ProfilesPath\*.json" | ForEach-Object { Write-Host " - $($_.BaseName)" }
}