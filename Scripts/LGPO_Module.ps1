# ================================
# LGPO Deploy Module
# ================================

$LGPOPath   = "$PSScriptRoot\..\LGPO\LGPO.exe"
$BackupPath = "$PSScriptRoot\..\Profiles\GPO_Backup"

function Test-LGPO {
    if (!(Test-Path $LGPOPath)) {
        Write-Host "LGPO.exe not found at $LGPOPath" -ForegroundColor Red
        Write-Host "Download from: https://microsoft.com/en-us/download/details.aspx?id=55319" -ForegroundColor Yellow
        return $false
    }
    return $true
}

function Export-GPO {
    if (!(Test-LGPO)) { return }
    New-Item -ItemType Directory -Force -Path $BackupPath | Out-Null
    & $LGPOPath /b $BackupPath
    Write-Host "GPO exported to: $BackupPath" -ForegroundColor Cyan
}

function Import-GPO {
    param([string]$BackupFolder = $BackupPath)
    if (!(Test-LGPO)) { return }
    if (!(Test-Path $BackupFolder)) {
        Write-Host "Backup folder not found: $BackupFolder" -ForegroundColor Red
        return
    }
    & $LGPOPath /g $BackupFolder
    gpupdate /force
    Write-Host "GPO imported and applied!" -ForegroundColor Green
}

function Export-GPO-Text {
    if (!(Test-LGPO)) { return }
    $txtPath = "$PSScriptRoot\..\Reports\current_gpo.txt"
    & $LGPOPath /parse /m "$env:SystemRoot\System32\GroupPolicy\Machine\Registry.pol" > $txtPath
    Write-Host "GPO exported as text to: $txtPath" -ForegroundColor Cyan
}