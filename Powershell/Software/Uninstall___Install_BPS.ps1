#Bind Variable To Application
$Uninstall = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "PS Finance Integration"}
$Install = "C:\Users\Rhys's Desktop\Desktop\Test\PS Finance Integration New.msi"

#Uninstall application
Sleep 5
Write-Host "PS Finance Integration will now be uninstalled" -ForegroundColor Black -BackgroundColor Cyan
$Uninstall.Uninstall()
Sleep 5
Write-Host "PS Finance Integration has now been uninstalled" -ForegroundColor Black -BackgroundColor Cyan

#Install application
Sleep 5
Write-Host "New version of PS Finance Integration will now be installed" -ForegroundColor Black -BackgroundColor Cyan
Install-Package -Name $Install -force
Sleep 5
Write-Host "PS Finance Integration has now been installed" -ForegroundColor Black -BackgroundColor Cyan
Sleep 5

#Copy Config File Over
Write-Host "PSFinanceAcademy.exe.config will now be copied over" -ForegroundColor Black -BackgroundColor Cyan
Sleep 5
Copy-Item "C:\Users\Rhys's Desktop\Desktop\Test\PSFinanceAcademy.exe.config" -Destination "C:\Program Files (x86)\Orovia Software Pvt.Ltd\PS Finance Integration\"
Write-Host "PSFinanceAcademy.exe.config has now been copied over" -ForegroundColor Black -BackgroundColor Cyan
Sleep 5

#Copy File Over
Write-Host "Application Connection will now be copied over" -ForegroundColor Black -BackgroundColor Cyan
Copy-Item "C:\Users\Rhys's Desktop\Desktop\Test\Application Connection" -Destination "C:\Program Files (x86)\Orovia Software Pvt.Ltd\"

Sleep 5
Write-Host "Application Connection has now been copied over" -ForegroundColor Black -BackgroundColor Cyan

#Finshed Output
Sleep 5
Write-Host "Script Finished" -ForegroundColor Black -BackgroundColor Cyan