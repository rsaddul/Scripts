
#Check Volumes with labled with three letters
$vols = get-Volume | ?{$_.filesystemlabel.length -eq 3}

#
$vols | ForEach-Object {
    $letter = $_.DriveLetter
    $code = $_.FileSystemLabel

    $Volume = $letter + ":\" + $code + "\Users\DfsrPrivate"
    $TestA = Test-Path $Volume
    If ($TestA -eq $true)
{
Write-Host "deleting $Volume"
Remove-Item $VolumeA -Recurse 
}
else
{
Write-Host "Path Does Not Exist"
}

}
