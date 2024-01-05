If([Version](Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3682886D-A14B-43F3-9D35-3A891589BB2F}','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{3682886D-A14B-43F3-9D35-3A891589BB2F}' -Name DisplayVersion -ea SilentlyContinue) -ge '1.0.0000') {
Write-Host "Installed"
Exit 0
}
else {
Exit 1
}
