If([Version](Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{2FB70A9C-48A9-4B7D-B95A-8A621EA18856}','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{2FB70A9C-48A9-4B7D-B95A-8A621EA18856}' -Name DisplayVersion -ea SilentlyContinue) -ge '1.0.0000') {
Write-Host "Installed"
Exit 0
}
else {
Exit 1
}
