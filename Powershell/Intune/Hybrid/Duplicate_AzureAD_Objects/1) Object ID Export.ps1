<#
Developed by: Rhys Saddul
#>

$GroupId = "cd62b772-56ba-4cc6-a4a3-1b57572ed282"
$CsvPath = "C:\Users\RhysSaddul\OneDrive - eduthing\Desktop\Exports\Duplicate_ObjectIDs.csv"

# ==========================
# Connect to Microsoft Graph
# ==========================
Connect-MgGraph -Scopes "Group.Read.All", "Device.Read.All"

# ==========================
# Get the Group (by ID)
# ==========================
try {
    $Group = Get-MgGroup -GroupId $GroupId
}
catch {
    Write-Host "Azure AD group '$GroupId' not found."
    return
}

# ==========================
# Get Group Members
# ==========================
$Members = Get-MgGroupMemberAsDevice -GroupId $Group.Id -All

# ==========================
# Process Device Members
# ==========================
$Results = foreach ($Device in $Members) {

    [PSCustomObject]@{
        ObjectId   = $Device.Id
        DeviceName = $Device.DisplayName
    }
}

# ==========================
# Export to CSV
# ==========================
if ($Results) {
    $Results | Export-Csv -Path $CsvPath -NoTypeInformation
    Write-Host "Export complete: $CsvPath"
}
else {
    Write-Host "No device objects found in the group."
}
