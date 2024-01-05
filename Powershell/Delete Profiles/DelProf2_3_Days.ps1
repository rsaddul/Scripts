If ((Test-Path C:\HCUC\DelProf2.exe) -eq $false) {Copy-Item "\\resource.uc\netlogon\Scripts\DelProf\DelProf2.exe" -Destination "C:\HCUC\DelProf2.exe"}
$runpath = "C:\HCUC\DelProf2.exe"
$arguments = "/i /u"
Start-Process -filepath $runpath -ArgumentList $arguments