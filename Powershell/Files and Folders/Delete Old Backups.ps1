# Define the variables needed 
$Path = "\\Uxcolfs04\d$\ITServices\Logs\Azure Backups\*.csv" # folder where files are located
$DaysBack = "-9" # minimum age of files to delete
$CurrentDate = Get-Date
$DateToDelete = $CurrentDate.AddDays($DaysBack)
$LogFilePath = "\\Uxcolfs04\d$\ITServices\Logs\Azure Backups\Backup.log" # path and filename of log file

# Delete the files older than the specified date
$FilesToDelete = Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DateToDelete }
foreach ($File in $FilesToDelete) {
    Remove-Item $File.FullName -WhatIf
}

# Log the action
if ($FilesToDelete.Count -gt 0) {
    $LogMessage = "{0} files deleted from {1} older than {2}" -f $FilesToDelete.Count, $Path, $DateToDelete.ToShortDateString()
    Add-Content -Path $LogFilePath -Value $LogMessage
}
