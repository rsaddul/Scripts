If([Version](Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{30B13C74-F503-4E5A-8DE0-217BE03BFB62}','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{30B13C74-F503-4E5A-8DE0-217BE03BFB62}' -Name DisplayVersion -ea SilentlyContinue) -ge '2.8.0') {
Write-Host "Installed"
Exit 0
}
else {
Exit 1
}
