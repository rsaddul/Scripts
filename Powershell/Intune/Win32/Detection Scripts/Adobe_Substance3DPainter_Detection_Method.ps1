If([Version](Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{52051924-0E05-411C-9A7D-01B2116A4323}','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{52051924-0E05-411C-9A7D-01B2116A4323}' -Name DisplayVersion -ea SilentlyContinue) -ge '1.0.0000') {
Write-Host "Installed"
Exit 0
}
else {
Exit 1
}
