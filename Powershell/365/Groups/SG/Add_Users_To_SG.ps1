<#
Developed by: Rhys Saddul
#>

# Install the AzureAD module if not already installed
if (-not (Get-Module -Name AzureAD -ListAvailable)) {
    Write-Host "Installing AzureAD module..."
    Install-Module -Name AzureAD -Scope CurrentUser -Force
}

# Import the AzureAD module
Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Base Variables
$csvFilePath = "C:\Users\RhysSaddul\OneDrive - eduthing\Documents\Schools\CCPS\Staff_Group_Add.csv" # Define the CSV file path directly

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
        $groupId = $user.GroupID
        $member = $user.Member

        # Retrieve the group object
        $group = Get-AzureADGroup -Filter "DisplayName eq '$groupId'"

        if ($group -eq $null) {
            Write-Warning "[ERROR] Group $groupId not found."
            $failedUsers += $member
            continue
        }

        # Retrieve the user object
        $userObject = Get-AzureADUser -Filter "UserPrincipalName eq '$member'"

        if ($userObject -eq $null) {
            Write-Warning "[ERROR] User $member not found."
            $failedUsers += $member
            continue
        }

        # Check if the user is already a member of the group
        $groupMembers = Get-AzureADGroupMember -ObjectId $group.ObjectId

        if (-not ($groupMembers.ObjectId -contains $userObject.ObjectId)) {
            Add-AzureADGroupMember -ObjectId $group.ObjectId -RefObjectId $userObject.ObjectId -ErrorAction Stop
            Write-Host "[PASS] Added $member to group $groupId" -ForegroundColor Green
            $successUsers += $member
        } else {
            Write-Host "[WARNING] $member already exists in Security Group $groupId" -ForegroundColor Yellow
            $usersAlreadyExist += $member
        }
    } catch {
        Write-Host "[ERROR] Can't add $member to $groupId. Error: $_" -ForegroundColor Red
        $failedUsers += $member
    }
}

# Log the results
$baseFileName = [System.IO.Path]::GetFileNameWithoutExtension($csvFilePath)
$failedUsers | Out-File -FilePath "$logFolder\$baseFileName FailedUsers.log" -Force -Verbose
$usersAlreadyExist | Out-File -FilePath "$logFolder\$baseFileName UsersAlreadyExist.log" -Force -Verbose
$successUsers | Out-File -FilePath "$logFolder\$baseFileName SuccessUsers.log" -Force -Verbose

Write-Host "Processing complete. Logs saved to $logFolder." -ForegroundColor Green

# Disconnect from Azure AD
Disconnect-AzureAD -Confirm:$false
