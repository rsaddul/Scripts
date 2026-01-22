<#
Developed by: Rhys Saddul
#>

# Install and import the ExchangeOnlineManagement module if not already installed
if (-not (Get-Module ExchangeOnlineManagement -ErrorAction SilentlyContinue)) {
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
}
Import-Module ExchangeOnlineManagement

Connect-ExchangeOnline -ShowProgress $true -ShowBanner:$false

# Path to the input CSV file with the user list
$inputCsvPath = "C:\Users\RhysSaddul\Downloads\Export_Aliases_Input.csv"

# Path to the output CSV file
$outputCsvPath = "C:\Users\RhysSaddul\Downloads\Export_Aliases_Output.csv"

# Read the user list from the input CSV
$userList = Import-Csv -Path $inputCsvPath -Header "UserPrincipalName"

# Initialise an array to store the results
$results = @()

# Loop through each user in the list
foreach ($user in $userList) {
    try {
        # Get the mailbox for the user
        $mailbox = Get-Mailbox -Identity $user.UserPrincipalName

        # Filter and format the email addresses
        $capitalSmtpAliases = $mailbox.EmailAddresses | Where-Object { $_ -cmatch "^SMTP:" }
        $capitalSmtpAliasesString = ($capitalSmtpAliases -join ";")

        $lowercaseSmtpAliases = $mailbox.EmailAddresses | Where-Object { $_ -cmatch "^smtp:" }
        $lowercaseSmtpAliasesString = ($lowercaseSmtpAliases -join ";")

        # Create an object with the user's display name, UPN, and aliases
        $userAliases = [PSCustomObject]@{
            DisplayName             = $mailbox.DisplayName
            UserPrincipalName       = $mailbox.UserPrincipalName
            CapitalSMTPAliases      = $capitalSmtpAliasesString
            LowercaseSMTPAliases    = $lowercaseSmtpAliasesString
        }

        # Add the result to the array
        $results += $userAliases
    }
    catch {
        Write-Warning "Unable to retrieve mailbox for $($user.UserPrincipalName): $_"
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path $outputCsvPath -NoTypeInformation

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
