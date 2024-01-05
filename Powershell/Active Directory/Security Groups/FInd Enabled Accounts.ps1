$GroupName = "SEC-O365-LICENCED"
$Domain = "resource.uc"

$Group = Get-Adgroup $GroupName -Server $Domain -Properties Members

$Count = Get-ADGroupMember -Identity $GroupName

($Count).Count

Foreach ($Member in $Group.Members){
$User = Get-ADUser $Member -Server $Domain -Properties Enabled

IF ($User.Enabled -eq $False ) {
$Username = $User.SamAccountName
Write-Host "User $Username is disabled"
}
}
