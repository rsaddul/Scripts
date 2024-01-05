###########################
# Devloped by Rhys Saddul #
###########################

Connect-MsolService
Connect-ExchangeOnline

$Email = Read-Host "Please Enter User Email"

#Find User Error
Get-MsolUser -UserPrincipalName "$Email" | Format-List DisplayName,UserPrincipalName,@{Name="Error";Expression={($_.errors[0].ErrorDetail.objecterrors.errorrecord.ErrorDescription)}}

$GUID = Read-Host "Please Enter User GUID"

#Search in EXO PowerShell for the object that is using the mentioned EXchangeGUID or ArchiveGUID:
$Check = Get-Recipient -IncludeSoftDeletedRecipients $GUID


If ($Check.RecipientType -like "*UserMailbox*"){

$Mailbox = $Check.RecipientType
$Name = $Check.Name

Write-Host "Removing $Mailbox for $Name"
Set-Mailbox $Email -LitigationHoldEnabled $false -InactiveMailbox 
Remove-Mailbox "$GUID" -PermanentlyDelete
Get-MsolUser -UserPrincipalName $Email | Format-List *objectID*

}
Else {
Write-Host "Removing $Mailbox for $Name"
Set-Mailbox $Email -LitigationHoldEnabled $false -InactiveMailbox
Remove-MailUser "$GUID" -PermanentlyDelete
Get-MsolUser -UserPrincipalName $Email | Format-List *objectID*
}

# Paste the ObjectId value from above command
Redo-MsolProvisionUser -ObjectId ‘4c0ade79-25dc-4bc2-9dff-9d3d7c325a99’

# Wait for 5 minutes and then run the next command, to confirm if your validation error is fixed:
(Get-MsolUser -UserPrincipalName $Email).errors.errordetail.objecterrors.errorrecord | Format-List


#Errors For All Users
#Get-MsolUser -HasErrorsOnly | fl DisplayName,UserPrincipalName,@{Name="Error";Expression={($_.errors[0].ErrorDetail.objecterrors.errorrecord.ErrorDescription)}} 

#Run this to get the conflicting GUID
#(Get-MsolUser -UserPrincipalName $Email).errors.errordetail.objecterrors.errorrecord

#Export Logs
#Get-MsolUser -HasErrorsOnly | select DisplayName,UserPrincipalName,@{Name="Error";Expression={($_.errors[0].ErrorDetail.objecterrors.errorrecord.ErrorDescription)}} | Export-csv c:\tempvalidationerrors.csv 