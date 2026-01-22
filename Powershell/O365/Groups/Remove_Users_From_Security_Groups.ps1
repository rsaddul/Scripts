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
#Connect-AzureAD

# Base Variables
$csvFilePath = "C:\Users\RhysSaddul\Downloads\Remove_Users_From_Security_Groups.csv"
$logFolder = "C:\temp"

# Ensure the log folder exists
if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory -Force
}

# Import the CSV file
$usersList = Import-Csv -Path $csvFilePath
$failedUsers = @()
$successUsers = @()

# Validate CSV structure
if ($usersList -and !($usersList | Get-Member -Name "GroupID" -ErrorAction SilentlyContinue) -or !($usersList | Get-Member -Name "Member" -ErrorAction SilentlyContinue)) {
    Write-Host "CSV file does not contain the required columns (GroupID, Member). Exiting script." -ForegroundColor Red
    return
}

# Process each user in the CSV file
foreach ($user in $usersList) {
    try {
        $groupId = $user.GroupID
        $member = $user.Member

        # Retrieve the group object
        $group = Get-AzureADGroup -Filter "DisplayName eq '$groupId'"
        if (-not $group) {
            Write-Host "[ERROR] Group $groupId not found. Skipping $member." -ForegroundColor Red
            $failedUsers += $member
            continue
        }

        # Retrieve the user object
        $userObject = Get-AzureADUser -Filter "UserPrincipalName eq '$member'"
        if (-not $userObject) {
            Write-Host "[ERROR] User $member not found. Skipping." -ForegroundColor Red
            $failedUsers += $member
            continue
        }

        # Check if the user is a member of the group
        $groupMembers = Get-AzureADGroupMember -ObjectId $group.ObjectId | Where-Object { $_.ObjectId -eq $userObject.ObjectId }

        if ($groupMembers) {
            # User is a member of the group, attempt to remove them
            Remove-AzureADGroupMember -ObjectId $group.ObjectId -MemberId $userObject.ObjectId -ErrorAction Stop
            Write-Host "[PASS] Removed $member from group $groupId" -ForegroundColor Green
            $successUsers += $member
        } else {
            Write-Host "[INFO] User $member is not a member of group $groupId. Skipping." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "[ERROR] Failed to remove $member from group $groupId. Error: $_" -ForegroundColor Red
        $failedUsers += $member
    }
}

# Log the results
$failedUsers | Out-File -FilePath "$logFolder\FailedUsers.log" -Force -Verbose
$successUsers | Out-File -FilePath "$logFolder\SuccessUsers.log" -Force -Verbose

Write-Host "Processing complete. Logs saved to $logFolder." -ForegroundColor Green

# Disconnect from Azure AD
#Disconnect-AzureAD -Confirm:$false
