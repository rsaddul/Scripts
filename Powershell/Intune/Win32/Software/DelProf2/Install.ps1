If ((Test-Path C:\DelProf2.exe) -eq $false) {Copy-Item "DelProf2.exe" -Destination "C:\DelProf2.exe"}
$runpath = "C:\DelProf2.exe"
$arguments = "/i /u"
Start-Process -filepath $runpath -ArgumentList $arguments