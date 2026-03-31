# ================================
# CIS Hardening Tool - WPF GUI
# ================================
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
Add-Type -AssemblyName PresentationFramework

# Load modules
. "$PSScriptRoot\..\Scripts\ProfileManager.ps1"
. "$PSScriptRoot\..\Scripts\LGPO_Module.ps1"

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="CIS Windows Hardening Tool - SVIIT"
        Height="550" Width="520"
        WindowStartupLocation="CenterScreen"
        Background="#1e1e2e" ResizeMode="NoResize">
  <StackPanel Margin="25">

    <TextBlock Text="🛡 CIS Windows Hardening Tool"
               FontSize="20" FontWeight="Bold"
               Foreground="#cdd6f4" Margin="0,0,0,5"/>
    <TextBlock Text="Shri Vaishnav Institute of Information Technology"
               FontSize="11" Foreground="#6c7086" Margin="0,0,0,20"/>

    <Button Name="btnHarden"   Content="⚡  Apply CIS Hardening"
            Height="48" Margin="0,5" Background="#89b4fa"
            FontWeight="Bold" FontSize="13" Cursor="Hand"/>

    <Button Name="btnAudit"    Content="🔍  Run Compliance Check"
            Height="48" Margin="0,5" Background="#a6e3a1"
            FontWeight="Bold" FontSize="13" Cursor="Hand"/>

    <Button Name="btnExport"   Content="📤  Export GPO Backup"
            Height="48" Margin="0,5" Background="#f9e2af"
            FontWeight="Bold" FontSize="13" Cursor="Hand"/>

    <Button Name="btnImport"   Content="📥  Import GPO Backup"
            Height="48" Margin="0,5" Background="#fab387"
            FontWeight="Bold" FontSize="13" Cursor="Hand"/>

    <Button Name="btnProfiles" Content="📋  List Profiles"
            Height="48" Margin="0,5" Background="#cba6f7"
            FontWeight="Bold" FontSize="13" Cursor="Hand"/>

    <Button Name="btnUndo"     Content="↩  Undo Hardening"
            Height="48" Margin="0,5" Background="#f38ba8"
            FontWeight="Bold" FontSize="13" Cursor="Hand"/>

    <TextBlock Text="Activity Log:" Foreground="#6c7086"
               Margin="0,15,0,5" FontSize="11"/>
    <TextBox Name="txtLog"
             Height="120" Background="#313244"
             Foreground="#cdd6f4" FontFamily="Consolas"
             FontSize="12" IsReadOnly="True"
             VerticalScrollBarVisibility="Auto"
             BorderBrush="#45475a" Padding="8"
             Text="[Ready] Select an action above..."/>

  </StackPanel>
</Window>
"@

$reader = [System.Xml.XmlNodeReader]::new($xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
$log    = $window.FindName("txtLog")

function Write-Log {
    param([string]$msg)
    $time = Get-Date -Format "HH:mm:ss"
    $log.Text += "`n[$time] $msg"
    $log.ScrollToEnd()
}

$window.FindName("btnHarden").Add_Click({
    Write-Log "Applying CIS Hardening..."
    try {
        & "$PSScriptRoot\..\Scripts\Harden.ps1"
        Write-Log "✅ Hardening applied successfully!"
    } catch {
        Write-Log "❌ Error: $_"
    }
})

$window.FindName("btnAudit").Add_Click({
    Write-Log "Running compliance check..."
    try {
        & "$PSScriptRoot\..\Scripts\ComplianceReport.ps1"
        Write-Log "✅ Report saved to Reports\report.txt"
    } catch {
        Write-Log "❌ Error: $_"
    