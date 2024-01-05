#Define the variables needed (PSF SQL Backups)

$Path = "F:\PSFLIVE Backup\*.bak" #folder where files are
$Daysback = "-7" #Minimum age of files to delete
$CurrentDate = Get-Date #Todays date
$DatetoDelete = $CurrentDate.AddDays($Daysback) #Calcaulate the date before which to delete files
$LogProgress = "F:\Logs\Backup.log" #Name of log file

#Delete the files older than specified
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item 


