#Checks if ExchangeOnlineManagment module exists and install if not

$Module = Get-module -Name ExchangeOnlineManagement 

If (-not $Module) {
Write-Host "ExchangeOnlineManagement is not installed, will now attempt to install" -ForegroundColor Red
Install-Module ExchangeOnlineManagement -Force
}
Else {
Write-Host "ExchangeOnlineManagement is installed" -ForegroundColor Green
}


#Connect to your 365 Account
Connect-ExchangeOnline

#Logs
$Calendars_Logs = "c:\Calendar_Logs.csv"


#This will export the report into a CSV
get-mailbox -RecipientTypeDetails Scheduling | Select-Object Name, PrimarySMTPAddress, RecipientTypeDetails | Export-Csv -Path $Calendars_logs -NoTypeInformation


#Add the permissions command to an array
$Array = @(

get-mailbox -RecipientTypeDetails Scheduling | Select-Object Name

)


#Loop through eachmailbox and get the permissions
$Permissions_Logs =  Foreach ($Mailbox in $Array) { 

Get-MailboxPermission -Identity $Mailbox.Name

}

$Permissions_Logs | Export-Csv -Path "c:\Permission_Logs.csv"