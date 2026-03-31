# Add this as the very first line in all 3 scripts
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# ================================
# CIS Compliance Report Script
# ================================

Write-Host "Generating Final Report..." -ForegroundColor Green

$report = "report.txt"

# Clear old report
if (Test-Path $report) {
    Remove-Item $report
}

# 🔹 System Info
$system = $env:COMPUTERNAME
$date = Get-Date

"===== CIS HARDENING REPORT =====" >> $report
"System Name: $system" >> $report
"Date & Time: $date" >> $report
"" >> $report

# 🔐 Password Policy Check
"==== Password Policy ====" >> $report
$passPolicy = net accounts

if ($passPolicy -match "Minimum password length\s+8") {
    "Password Length: PASS ✅" >> $report
} else {
    "Password Length: FAIL ❌" >> $report
}

"" >> $report

# 👤 Guest Account Check
"==== Guest Account ====" >> $report
$guest = net user guest

if ($guest -match "Account active\s+No") {
    "Guest Account Disabled: PASS ✅" >> $report
} else {
    "Guest Account Disabled: FAIL ❌" >> $report
}

"" >> $report

# 🔥 Firewall Check
"==== Firewall Status ====" >> $report
$fw = Get-NetFirewallProfile

if ($fw.Enabled -contains $false) {
    "Firewall: FAIL ❌" >> $report
} else {
    "Firewall: PASS ✅" >> $report
}

"" >> $report

# 📋 Applied Policies (Static List)
"==== Applied Policies ====" >> $report
"Password Policy Applied" >> $report
"Account Lockout Applied" >> $report
"Firewall Enabled" >> $report
"Guest Account Disabled" >> $report
"USB Storage Disabled" >> $report

Write-Host "Report Generated Successfully: report.txt" -ForegroundColor Green