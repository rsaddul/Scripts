
#Create array of groups in question
$Array = @(
"SEC-O365-LICENCED",
"SEC-HC-Staff"
)


#Check each group in array and provide a count of users
ForEach ($I in $Array) {
$Count = Get-ADGroup -Identity $I -Properties Members
$Numbers = $Count.Members.Count
Write-Host "$I has $Numbers members in the group" -ForegroundColor Green
}

##########################################################################################################################################



