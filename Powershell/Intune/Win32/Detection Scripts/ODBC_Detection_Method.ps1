If([Version](Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{F89605E4-B8A7-46ED-84E7-6AB7F2CFD9BC}','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{F89605E4-B8A7-46ED-84E7-6AB7F2CFD9BC}' -Name DisplayVersion -ea SilentlyContinue) -ge '13.1.811.168') {
Write-Host "Installed"
Exit 0
}
else {
Exit 1
}
