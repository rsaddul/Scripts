<#
Developed by: Rhys Saddul
#>

# ==========================
# Configuration
# ==========================
$CsvFilePath = "C:\Users\RhysSaddul\OneDrive - eduthing\Desktop\Exports\Duplicate_ObjectIDs.csv"

# ==========================
# Connect to Microsoft Graph
# ==========================
Connect-MgGraph -Scopes "Device.ReadWrite.All"

# ==========================
# Import Object IDs
# ==========================
$ObjectIds = Import-Csv -Path $CsvFilePath | ForEach-Object { $_.ObjectId }

if (-not $ObjectIds) {
    Write-Host "No ObjectIds found in CSV."
    return
}

# ==========================
# Remove Devices
# ==========================
foreach ($ObjectId in $ObjectIds) {
    try {
        Remove-MgDevice -DeviceId $ObjectId -ErrorAction Stop
        Write-Host "✅ Device with ObjectId $ObjectId removed."
    }
    catch {
        Write-Host "❌ Failed to remove device with ObjectId $ObjectId"
    }
}

# ==========================
# Disconnect
# ==========================
Disconnect-MgGraph
