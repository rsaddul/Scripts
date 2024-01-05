If([Version](Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{6634E43A-D765-4964-A64C-A330BAF0D296}','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{6634E43A-D765-4964-A64C-A330BAF0D296}' -Name DisplayVersion -ea SilentlyContinue) -ge '1.0.0000') {
Write-Host "Installed"
Exit 0
}
else {
Exit 1
}
