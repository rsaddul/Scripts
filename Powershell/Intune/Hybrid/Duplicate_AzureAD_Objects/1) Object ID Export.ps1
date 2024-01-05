# Define the Azure AD group
$GroupName = "HRUC H-CloudSec - Hybird Object ClearUp (HCUC)"

# Get the Azure AD group
$Group = Get-AzureADGroup -Filter "DisplayName eq '$GroupName'"

# Check if the group exists
if ($Group) {
    # Get the members of the group
    $Members = Get-AzureADGroupMember -ObjectId $Group.ObjectId

    # Initialize an array to store the object IDs and device names
    $Results = @()

    # Loop through the members and retrieve their object IDs and device names
    foreach ($Member in $Members) {
        $ObjectId = $Member.ObjectId

        # Check if the member is a device
        if ($Member.ObjectType -eq "Device") {
            $Device = Get-AzureADDevice -ObjectId $ObjectId
            $DeviceName = $Device.DisplayName

            # Add the object ID and device name to the result array
            $Results += [PSCustomObject]@{
                ObjectId   = $ObjectId
                DeviceName = $DeviceName
            }
        }
    }

    # Output the result to a CSV file
    $Results | Export-Csv -Path "C:\Duplicate_ObjectIDs.csv" -NoTypeInformation
}
else {
    Write-Host "Azure AD group '$GroupName' not found."
}
