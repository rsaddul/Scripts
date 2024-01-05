Connect-MsolService


Get-MsolGroup -All -GroupType Security | Where-Object {(Get-MsolGroupMember -GroupObjectId $_.ObjectId).count -eq 0 } | Select-Object DisplayName, GroupType, LastDirSyncTime | Export-Csv -Path C:\Security.csv

Get-MsolGroup -GroupType DistributionList -MaxResults | Where-Object {(Get-MsolGroupMember -GroupObjectId $_.ObjectId).count -eq 0 } | Select-Object DisplayName, Description, EmailAddress, GroupType, LastDirSyncTime | Export-Csv -Path C:\Distribution.csv

Get-MsolGroup -GroupType MailenabledSecurity -MaxResults | Where-Object {(Get-MsolGroupMember -GroupObjectId $_.ObjectId).count -eq 0 } | Select-Object DisplayName, EmailAddress, GroupType, LastDirSyncTime, ValidationStatus | Export-Csv -Path C:\MailEnabledSecurity.csv


Get-ADGroup -Filter * -SearchBase "OU=HCUC,DC=resource,DC=uc" -Properties Members | Where-Object {$_.Members.count -eq 0} | Select Name | Export-Csv C:\HCUC_EmptyADGroups.csv –NoTypeInformation


Get-ADGroup -Filter * -SearchBase "OU=Uxbridge College,DC=resource,DC=uc" -Properties Members | Where-Object {$_.Members.count -eq 0} | Select Name | Export-Csv C:\UX_EmptyADGroups.csv –NoTypeInformation
