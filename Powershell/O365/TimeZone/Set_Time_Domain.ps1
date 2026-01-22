<#
Developed by: Rhys Saddul

Overview:

This will set all mailboxes in the "bhcs.sfet.org.uk" domain to the specified TimeZone, DateFormat, and Language.

Issue Context:

Mailboxes in Exchange Online have two time zones; one in regional settings and the other in working hours.
These are both set to Pacific Standard Time by default, regardless of where the mailbox is created or what tenant or Exchange regional settings are in place.
According to Microsoft support, this behavior is by design.
The first time a mailbox is accessed, these settings are adjusted based on the user's location, but resource mailboxes may retain defaults indefinitely.

#>

# Check if ExchangeOnlineManagement module is installed
if (-not (Get-Module -Name ExchangeOnlineManagement -ListAvailable)) {
    Install-Module -Name ExchangeOnlineManagement -Force -Scope CurrentUser -AllowClobber
    Import-Module -Name ExchangeOnlineManagement
    Write-Host "ExchangeOnlineManagement module installed and imported successfully." -ForegroundColor Red
}

Connect-ExchangeOnline -ShowBanner:$false # --------- Connect to Exchange Online --------- #

$Region = "GMT Standard Time"
$DateFormat = "dd/MM/yyyy"
$Language = "en-GB"

Get-Mailbox -ResultSize Unlimited | Where-Object { $_.PrimarySmtpAddress -like "*@bhcs.sfet.org.uk" } | foreach {
    $UPN = $_.PrimarySmtpAddress
    Write-Host "Setting time zones and regional settings for mailbox: $UPN" -ForegroundColor Green
    
    # Set Calendar and Regional configurations
    Set-MailboxCalendarConfiguration -Identity $UPN -WorkingHoursTimeZone $Region
    Set-MailboxRegionalConfiguration -Identity $UPN -TimeZone $Region -Language $Language -DateFormat $DateFormat -Confirm:$False
}

Disconnect-ExchangeOnline -Confirm:$false  # --------- Disconnect from Exchange Online --------- #
