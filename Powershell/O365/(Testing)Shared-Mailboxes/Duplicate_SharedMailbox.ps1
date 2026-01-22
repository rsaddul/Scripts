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

# Define variables
$MailboxName = "Finance"
$Alias = "Finance2" # If creating multiple finance boxes for more than one domain be sure to increment this nummber
$SubDomain = "@batleyparish.enhanceacad.org.uk"
$Domain = "@enhanceacad.org.uk"
$OnMicrosoft = "@enhanceacademytrust.onmicrosoft.com"

# Varibles that dont need changing
$PrimarySMTPAddress = "$MailboxName$SubDomain"
$NewMicrosoftOnlineServicesID = "$MailboxName$SubDomain"
$RemoveEmailAddresses = @("$Alias$OnMicrosoft", "$Alias$Domain")

# Connect to Exchange Online
Connect-ExchangeOnline

# Create new shared mailbox
New-Mailbox -Name $MailboxName -Alias $Alias -Shared -PrimarySMTPAddress $PrimarySMTPAddress

# Display mailbox info before modification
Get-Mailbox $Alias | Select-Object Name, Alias, UserPrincipalName

# Set new Microsoft Online Services ID
Set-Mailbox $Alias -MicrosoftOnlineServicesID $NewMicrosoftOnlineServicesID

# Display mailbox info after setting Microsoft Online Services ID
Get-Mailbox $Alias | Select-Object Name, Alias, UserPrincipalName

# Display mailbox info including email addresses before modification
Get-Mailbox $Alias | Select-Object Name, Alias, UserPrincipalName, EmailAddresses

# Remove specified email addresses
Set-Mailbox $Alias -EmailAddresses @{remove=$RemoveEmailAddresses}

# Display mailbox info including email addresses after modification
Get-Mailbox $Alias | Select-Object Name, Alias, UserPrincipalName, EmailAddresses
