If ((Test-Path C:\Remove-Consumer-Apps.ps1) -eq $false) {Copy-Item "\\resource.uc\netlogon\OSD\Remove-Consumer-Apps.ps1" -Destination "C:\Remove-Consumer-Apps.ps1"}
$runpath = "C:\Remove-Consumer-Apps.ps1"
Start-Process -filepath $runpath