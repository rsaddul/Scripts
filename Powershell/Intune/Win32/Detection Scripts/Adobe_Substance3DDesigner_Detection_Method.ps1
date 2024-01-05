If([Version](Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{D1423872-2EFA-4E1B-BA4C-40D70C87A303}','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{D1423872-2EFA-4E1B-BA4C-40D70C87A303}' -Name DisplayVersion -ea SilentlyContinue) -ge '1.0.0000') {
Write-Host "Installed"
Exit 0
}
else {
Exit 1
}
