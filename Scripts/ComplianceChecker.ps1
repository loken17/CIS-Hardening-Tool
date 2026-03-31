# Add this as the very first line in all 3 scripts
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# ================================
# CIS Compliance Checker Script
# ================================

Write-Host "Checking System Compliance..." -ForegroundColor Green

# Output file
$report = "$PSScriptRoot\..\Reports\report.txt"

# Clear old report
if (Test-Path $report) {
    Remove-Item $report
}

# 🔐 1. Password Policy
Write-Host "Checking Password Policy..."
"==== Password Policy ====" >> $report
net accounts >> $report

# 👤 2. Guest Account Status
Write-Host "Checking Guest Account..."
"==== Guest Account ====" >> $report
net user guest >> $report

# 🔥 3. Firewall Status
Write-Host "Checking Firewall..."
"==== Firewall Status ====" >> $report
Get-NetFirewallProfile >> $report

# 💾 4. USB Storage Status
Write-Host "Checking USB Storage..."
"==== USB Storage ====" >> $report
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" >> $report

Write-Host "Compliance Report Generated on Desktop: report.txt" -ForegroundColor Green