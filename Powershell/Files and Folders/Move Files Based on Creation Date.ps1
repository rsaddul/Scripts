$Date = Get-Date -Format "MM/dd/yyyy"
$Time = Get-Date -Format "HH:mm"
$Path = "\\HCUC-RHYS-PC\Share1"
$ArchiveYear = 2022
$Archive = "\\HCUC-RHYS-PC\Share2"
$Creation = Get-ChildItem -Path $Path | Where-Object {$_.CreationTime -like "*$ArchiveYear*"}



$Creation | ForEach-Object {
Write-Host "$_ will now be moved to Student Archives" -ForegroundColor Red
Move-Item $Path\$_ -Destination $Archive -Force
"$Date - $Time - $_ was moved to $Archive" | Out-File "C:\Test.txt" -Append ascii}



# If you want to manually check
#Get-ChildItem -Path $Path | Select-Object CreationTime,Name

