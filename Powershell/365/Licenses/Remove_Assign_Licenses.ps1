# Install and import the AzureAD module if not already installed
# Install-Module -Name AzureAD
# Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Define the Office 365 group and the desired licenses
$groupName = "YourGroupDisplayName"
$oldLicenseSkuId = "your:old:license:sku:id"
$newLicenseSkuId = "your:new:license:sku:id"

# Initialize an array to store results
$results = @()

# Get the members of the Office 365 group
$group = Get-AzureADGroup -Filter "DisplayName eq '$groupName'"
$groupMembers = Get-AzureADGroupMember -ObjectId $group.ObjectId

# Iterate through group members and check/modify licenses
foreach ($member in $groupMembers) {
    $user = Get-AzureADUser -ObjectId $member.ObjectId -ExpandProperty AssignedLicenses
    
    # Check if the old license is assigned
    $oldLicenseAssigned = $user.AssignedLicenses | Where-Object { $_.SkuId -eq $oldLicenseSkuId }
    
    if ($oldLicenseAssigned) {
        Write-Host "Removing old license $($oldLicenseSkuId) from $($user.DisplayName)"
        
        # Construct a list of the license plans to be kept (excluding the old license)
        $newLicenses = $user.AssignedLicenses | Where-Object { $_.SkuId -ne $oldLicenseSkuId }

        # Update the user's assigned licenses with the new set of licenses
        Set-AzureADUserLicense -ObjectId $user.ObjectId -AssignedLicenses $newLicenses
        
        # Add the new license
        $user | Add-AzureADUserLicense -AssignedLicenses @{SkuId = $newLicenseSkuId}
        Write-Host "Added new license $($newLicenseSkuId) to $($user.DisplayName)"

        # Add result to the array
        $result = [PSCustomObject]@{
            "UserDisplayName" = $user.DisplayName
            "OldLicenseRemoved" = $oldLicenseSkuId
            "NewLicenseAdded" = $newLicenseSkuId
        }
        $results += $result
    }
    else {
        Write-Host "No old license found for $($user.DisplayName)"
    }
}

# Disconnect from Azure AD
Disconnect-AzureAD

# Export the results to a CSV file
$results | ForEach-Object {
    [PSCustomObject]@{
        "UserDisplayName" = $_.UserDisplayName
        "OldLicenseRemoved" = $_.OldLicenseRemoved
        "NewLicenseAdded" = $_.NewLicenseAdded
    }
} | Export-Csv -Path "LicenseChangeResults.csv" -NoTypeInformation
