## Check for Lenel_OnGuard (Registry Detection Method)
$Lenel_OnGuard = Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall","HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty | Where-Object {$_.DisplayName -like 'OnGuard*' } | Select-Object -Property DisplayName, DisplayVersion, PSChildName
$Lenel_OnGuard.DisplayVersion
$Lenel_OnGuard.PSChildName

## Create Text File with Lenel_OnGuard
$FilePath = "C:\Windows\Temp\Lenel_OnGuard_Detection_Method.txt"
New-Item -Path "$FilePath" -Force
Set-Content -Path "$FilePath" -Value "If([Version](Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$($Lenel_OnGuard.PSChildName)','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$($Lenel_OnGuard.PSChildName)' -Name DisplayVersion -ea SilentlyContinue) -ge '$($Lenel_OnGuard.DisplayVersion)') {"
Add-Content -Path "$FilePath" -Value "Write-Host `"Installed`""
Add-Content -Path "$FilePath" -Value "Exit 0"
Add-Content -Path "$FilePath" -Value "}"
Add-Content -Path "$FilePath" -Value "else {"
Add-Content -Path "$FilePath" -Value "Exit 1"
Add-Content -Path "$FilePath" -Value "}"
Invoke-Item $FilePath