<#
Developed by: Rhys Saddul
#>

# Check if Exchange Online PowerShell Module is installed
if (-not (Get-Module -Name ExchangeOnlineManagement -ListAvailable)) {
    Write-Host "ExchangeOnlineManagement module is not installed. Installing the module now..." -ForegroundColor Yellow
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
}

# Import the ExchangeOnlineManagement module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline

$csvPath = "C:\Users\RhysSaddul\OneDrive - eduthing\Desktop\BHCS_Staff.csv"

# Import the CSV file containing the list of email addresses
$emailList = Import-Csv -Path $csvPath

# Loop through each email address and disable the auto-reply configuration
foreach ($email in $emailList) {
    # Display the email address being processed
    Write-Host "Disabling auto-reply configuration for:" $email.EmailAddress

    # Disable the auto-reply configuration
    Set-MailboxAutoReplyConfiguration -Identity $email.EmailAddress `
        -AutoReplyState Disabled
}
