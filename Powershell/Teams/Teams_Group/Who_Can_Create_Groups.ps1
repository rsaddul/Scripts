# Developed by Rhys Saddul

# This will find the GroupCreationAllowedGroupId and the Group Name which is allowed to create teams groups

# Find the Group.Unified directory setting
$settingsObject = Get-AzureADDirectorySetting | Where-Object { $_.Displayname -eq "Group.Unified" }

# Check if the setting exists
if ($settingsObject -eq $null) {
    Write-Host "Group.Unified directory setting not found."
} else {
    # Display the current GroupCreationAllowedGroupId
    $currentGroupId = $settingsObject.Values | Where-Object { $_.Name -eq "GroupCreationAllowedGroupId" } | Select-Object -ExpandProperty Value

    if ($currentGroupId -eq $null) {
        Write-Host "GroupCreationAllowedGroupId is not currently set."
    } else {
        try {
            # Get the group based on the object ID
            $group = Get-AzureADGroup -ObjectId $currentGroupId

            if ($group -eq $null) {
                Write-Host "Group with ID $currentGroupId not found."
            } else {
                Write-Host "Current GroupCreationAllowedGroupId: $currentGroupId"
                Write-Host "Group Name: $($group.DisplayName)"
            }
        } catch {
            Write-Host "Error retrieving group: $_"
        }
    }
}
