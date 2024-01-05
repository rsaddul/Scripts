
#Build an array of all users in AD with enabled accounts
$Arrays = @(
$AD = Get-ADUser -Filter "enabled -eq '$True'"
)

#Loop through the array and count how many usergroups a member is part of
ForEach ($A in $AD){
$Count = Get-ADUser -id $A -Properties Memberof

#If the user exceeds 100 groups export this to a log
If ($Count.MemberOf.Count -ge 100) {
Write-Host $Count.Name is a member of $Count.MemberOf.Count usergroups  -ForegroundColor Red
$Name = $Count.Name 
$Number = $Count.MemberOf.Count
"$Name is a member of $Number usergroups" | Out-File "C:\Over_100.txt" -Append
}
#If the user is under 100 groups export this to a log
Else {
Write-Host $Count.Name is a member of $Count.MemberOf.Count usergroups -ForegroundColor Green
$Name = $Count.Name 
$Number = $Count.MemberOf.Count
"$Name is a member of $Number usergroups" | Out-File "C:\Under_100.txt" -Append
}
}

#Count on how many users in file
(Get-Content "C:\Under_100.txt").Length
(Get-Content "C:\Over_100.txt").Length
