<#
Developed by: Rhys Saddul
#>

# Install and import the ExchangeOnlineManagement module if not already installed
if (-not (Get-Module ExchangeOnlineManagement -ErrorAction SilentlyContinue)) {
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
}
Import-Module ExchangeOnlineManagement

# Prompt to ensure varibles have been setup correctly prior to running the script
$dialogResult = [System.Windows.Forms.MessageBox]::Show("Have you set the varible for the output file path?", "Variable Setup", "YesNo", "Question")
if ($dialogResult -eq "Yes") {
    Write-Host "User confirmed variables have been set. Proceeding with the script." -ForegroundColor Green
} else {
    Write-Host "User confirmed Variables have not been set. Exiting the script." -ForegroundColor Red
    return
}


# Connect to Exchange Online with progress display
Connect-ExchangeOnline -ShowProgress $true -ShowBanner:$false

# Import the CSV file
$mailboxData = Import-Csv -Path "C:\Users\RhysSaddul\Documents\PCIS New.csv"
# UserPrincipalName,ForwardingSmtpAddress
# user1@example.com,forward1@example.com

# Loop through each row in the CSV and execute the Set-Mailbox command
foreach ($row in $mailboxData) {
    Write-Host "Processing mailbox rule $($row.UserPrincipalName)" -ForegroundColor Yellow
    Set-Mailbox -Identity $row.UserPrincipalName -ForwardingSmtpAddress $row.ForwardingSmtpAddress -DeliverToMailboxAndForward $false
}

