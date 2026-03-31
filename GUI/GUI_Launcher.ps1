Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
Add-Type -AssemblyName PresentationFramework

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="CIS Hardening Tool - SVIIT" Height="420" Width="480"
        WindowStartupLocation="CenterScreen" Background="#1e1e2e">
  <StackPanel Margin="25">
    <TextBlock Text="🛡 CIS Windows Hardening Tool" FontSize="18"
               FontWeight="Bold" Foreground="White" Margin="0,0,0,20"/>
    <Button Name="btnHarden"  Content="⚡ Apply Hardening"         Height="45" Margin="0,5" Background="#89b4fa" FontWeight="Bold"/>
    <Button Name="btnAudit"   Content="🔍 Run Compliance Check"    Height="45" Margin="0,5" Background="#a6e3a1" FontWeight="Bold"/>
    <Button Name="btnExport"  Content="📤 Export GPO Backup"       Height="45" Margin="0,5" Background="#f9e2af" FontWeight="Bold"/>
    <Button Name="btnProfile" Content="📋 List Profiles"           Height="45" Margin="0,5" Background="#cba6f7" FontWeight="Bold"/>
    <TextBox Name="txtLog" Height="110" Margin="0,15,0,0"
             Background="#313244" Foreground="White"
             IsReadOnly="True" VerticalScrollBarVisibility="Auto"
             Text="Ready. Select an action above..."/>
  </StackPanel>
</Window>
"@

$reader  = [System.Xml.XmlNodeReader]::new($xaml)
$window  = [Windows.Markup.XamlReader]::Load($reader)
$log     = $window.FindName("txtLog")

$window.FindName("btnHarden").Add_Click({
    & "$PSScriptRoot\..\Scripts\Harden.ps1"
    $log.Text = "✅ Hardening Applied! Check Reports folder."
})
$window.FindName("btnAudit").Add_Click({
    & "$PSScriptRoot\..\Scripts\ComplianceReport.ps1"
    $log.Text = "📄 Report saved to Reports/report.txt"
})
$window.FindName("btnExport").Add_Click({
    . "$PSScriptRoot\..\Scripts\LGPO_Module.ps1"
    Export-GPO
    $log.Text = "📦 GPO Exported to Profiles/GPO_Backup/"
})
$window.FindName("btnProfile").Add_Click({
    . "$PSScriptRoot\..\Scripts\ProfileManager.ps1"
    $profiles = Get-ChildItem "$PSScriptRoot\..\Profiles\*.json" | Select -ExpandProperty BaseName
    $log.Text = "Profiles:`n" + ($profiles -join "`n")
})

$window.ShowDialog()