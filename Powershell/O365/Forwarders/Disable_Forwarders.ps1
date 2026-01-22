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

# Path to the CSV file
$csvPath = "C:\path\to\your\Disable_Forwarders.csv"

# Import the CSV file
$users = Import-Csv -Path $csvPath

# Loop through each user in the CSV
foreach ($user in $users) {
    $userEmail = $user.Email  # Ensure your CSV file has a column named 'Email'

    # Disable email forwarding
    Set-Mailbox -Identity $userEmail -DeliverToMailboxAndForward $false

    # Output 
    Write-Host "Disabled forwarding for $userEmail"
}
