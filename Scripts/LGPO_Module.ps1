$LGPOPath = "$PSScriptRoot\..\LGPO\LGPO.exe"
$BackupPath = "$PSScriptRoot\..\Profiles\GPO_Backup"

function Export-GPO {
    New-Item -ItemType Directory -Force -Path $BackupPath | Out-Null
    & $LGPOPath /b $BackupPath
    Write-Host "GPO Exported to $BackupPath" -ForegroundColor Cyan
}

function Import-GPO {
    param([string]$BackupFolder)
    & $LGPOPath /g $BackupFolder
    gpupdate /force
    Write-Host "GPO Applied!" -ForegroundColor Green
}