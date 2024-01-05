# Check if the Exchange Online module is installed
if (-not (Get-Module -Name ExchangeOnlineManagement -ListAvailable)) {
    Write-Host "Installing Exchange Online module..."

    # Install the Exchange Online module
    Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force
}

# Connect to Exchange Online
Connect-ExchangeOnline 

# Prompt the user for the group name
$GroupName = Read-Host "Enter the name of the existing mail-enabled security group"

# Check if the group exists in Exchange Online
$existingGroup = Get-DistributionGroup -Filter "Name -eq '$GroupName'"

if ($existingGroup) {
    # Import user data from CSV and add them to the group
    $CSVFilePath = Read-Host "Enter the path to the CSV file containing user data"
    $CSVData = Import-Csv -Path $CSVFilePath

    foreach ($User in $CSVData) {
        Add-DistributionGroupMember -Identity $GroupName -Member $User.Username
    }

    Write-Host "Users added to mail-enabled security group '$GroupName'." -ForegroundColor Green
}
else {
    Write-Host "Mail-enabled security group '$GroupName' does not exist." -ForegroundColor Red
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
