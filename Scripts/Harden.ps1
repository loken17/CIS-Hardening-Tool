# Add this as the very first line in all 3 scripts
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# ================================
# CIS Windows Hardening Script
# ================================

Write-Host "Starting System Hardening..." -ForegroundColor Green

# 🔐 1. Set Password Policy
Write-Host "Applying Password Policy..."
net accounts /minpwlen:8

# 🔒 2. Disable Guest Account
Write-Host "Disabling Guest Account..."
net user guest /active:no

# 🔥 3. Enable Firewall (All Profiles)
Write-Host "Enabling Windows Firewall..."
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

# 💾 4. Disable USB Storage
Write-Host "Disabling USB Storage..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -Value 4

# 🔐 5. Account Lockout Policy (Extra - Recommended)
Write-Host "Applying Account Lockout Policy..."
net accounts /lockoutthreshold:5
net accounts /lockoutduration:15
net accounts /lockoutwindow:15

Write-Host "System Hardening Completed Successfully!" -ForegroundColor Green