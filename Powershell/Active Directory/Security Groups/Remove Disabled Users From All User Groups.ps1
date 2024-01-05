
$ADUser = Get-ADUser -Filter * -Property Enabled


$ADUser | ForEach {
                    $ADUsername = $_.SamAccountName
                    $FullName = $_.Name
                    If($_.Enabled -like "True")

{
Get-ADPrincipalGroupMembership $ADUsername | Where-Object {$_.Name -ne "Domain Users"} | ForEach {
$GroupName = $_.Name
Remove-ADGroupMember -Identity $GroupName -Members $ADUsername -Confirm:$False -Verbose
$Output = "Removing $ADUsername from $GroupName" | Out-File "C:\log\Removed Groups.txt" -Append -Encoding ascii
Write-Host "Removing $ADUsername from $GroupName" -ForegroundColor Black -BackgroundColor Red
}
}
                                                   
}
