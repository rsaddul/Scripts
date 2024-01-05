#Define the variables needed

$Path = "G:\SAL\Profiles\DfsrPrivate\ConflictAndDeleted\*" #folder where files are
#$Daysback = "-365" #Minimum age of files to delete
$Daysback = "-180" #Minimum age of files to delete
$CurrentDate = Get-Date #Todays date
$DatetoDelete = $CurrentDate.AddDays($Daysback) #Calcaulate the date before which to delete files


#Delete the files older than specified
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Recurse -Force


