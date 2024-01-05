############################
# Developed by Rhys Saddul #
############################

$CSV = Import-CSV -Path "c:\1.csv"
$SuccessLog = "C:\Success_Log.txt"
$FailedLog = "C:\Failed_log.txt"

ForEach ($Cell in $CSV) {

$Old = $Cell.Old 
$New = $Cell.New

If (!(Test-Path -Path $New)){

Write-Host "Folder doesnt exist in $New" -ForegroundColor Red

robocopy $Old $New /e /copyall /r:1 /w:3

Write-Host "Moving $Old to $New" -ForegroundColor Green

"Moving $Old to $New" | Out-File -FilePath $SuccessLog

}
Else {

Write-Host "Path exists in $New" -ForegroundColor Green
"Folder already exists in $New so this has not been moved" | Out-File -FilePath $FailedLog

}
}

