<#
Developed by: Rhys Saddul

#>

# Install the Exchange Online Management module if not already installed
if (-not (Get-Module -Name ExchangeOnlineManagement -ListAvailable)) {
    Write-Host "Installing Exchange Online module..."
    Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force
}

# Import the Exchange Online Management module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline -ShowBanner:$false

# Base Varibles
$csvFilePath = "C:\Users\Rhys's Desktop\Desktop\New Scripts\M365 Group\Create.csv" # Define the CSV file path directly

# Check if the CSV file exists
if (-not (Test-Path -Path $csvFilePath)) {
    Write-Host "The specified CSV file does not exist. Exiting script." -ForegroundColor Red
    return
}

# Define log folder
$logFolder = "C:\temp"

# Ensure the log folder exists
if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory -Force
}

# Import the CSV file
$usersList = Import-Csv -Path $csvFilePath
$failedUsers = @()
$usersAlreadyExist = @()
$successUsers = @()

# Process each user in the CSV file
foreach ($user in $usersList) {
    try {
        $groupId = $user.groupid
        $member = $user.member

        # Check if the user is already a member of the group
        if (-not ((Get-UnifiedGroupLinks -Identity $groupId -LinkType Members).PrimarySmtpAddress -contains $member)) {
            Add-UnifiedGroupLinks -Identity $groupId -LinkType Members -Links $member -ErrorAction Stop
            Write-Verbose "[PASS] Added $member to group $groupId"
            $successUsers += $member
        } else {
            Write-Warning "[WARNING] $member already exists in M365 Group $groupId"
            $usersAlreadyExist += $member
        }
    } catch {
        Write-Warning "[ERROR] Can't add $member to $groupId. Error: $_"
        $failedUsers += $member
    }
}

# Log the results
$baseFileName = [System.IO.Path]::GetFileNameWithoutExtension($csvFilePath)
$failedUsers | Out-File -FilePath "$logFolder\$baseFileName FailedUsers.log" -Force -Verbose
$usersAlreadyExist | Out-File -FilePath "$logFolder\$baseFileName UsersAlreadyExist.log" -Force -Verbose
$successUsers | Out-File -FilePath "$logFolder\$baseFileName SuccessUsers.log" -Force -Verbose

Write-Host "Processing complete. Logs saved to $logFolder." -ForegroundColor Green

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false