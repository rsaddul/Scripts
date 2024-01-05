# When a Win32 app is installed via Intune, it's installed via the Microsoft Intune Management Extension (IME) agent
# If you want to force a reinstall of all apps deployed, you can simply delete the user id key. But if you want to force a reinstall of a single app, you need to delete the app id under the user key
# The below will delete the user id key and force a reinstall of all apps deployed

$User = "rsaddul"
$AD = get-aduser -identity $User | Select-Object SamAccountName
$UserGuid = powershell { (get-aduser -identity rsaddul).ObjectGUID }


$Win32 =  test-Path -Path "HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps\7d87c43d-8d69-4cd4-acb1-2c63fe698117"

If ($Win32 -eq "false") {
Write-Host "Key does not exist" -ForegroundColor Red
}
Else {
Write-Host "Removing $UserGuid for $AD" -ForegroundColor Green
Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps -name "7d87c43d-8d69-4cd4-acb1-2c63fe698117" -Force -Verbose 
Write-Host "Restarting Microsoft Intune Management Service" -ForegroundColor Green
Restart-Service "IntuneManagementExtension"
}