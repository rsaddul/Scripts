If([Version](Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AC76BA86-1033-FFFF-7760-BC15014EA700}','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{AC76BA86-1033-FFFF-7760-BC15014EA700}' -Name DisplayVersion -ea SilentlyContinue) -ge '23.001.20174') {
Write-Host "Installed"
Exit 0
}
else {
Exit 1
}
