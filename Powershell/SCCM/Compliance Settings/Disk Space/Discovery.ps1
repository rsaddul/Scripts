# Define minimum free disk space threshold
$minFreeSpaceGB = 300

# Get available disk space for C drive
$drive = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"
$freeSpaceGB = [math]::Round(($drive.FreeSpace/1GB), 2)

# Check if free space is less than minimum threshold
if ($freeSpaceGB -lt $minFreeSpaceGB) {
    Write-Output "Low disk space detected on C drive. Free space: $freeSpaceGB GB"
    exit 1
}
else {
    Write-Output "C drive has sufficient free space. Free space: $freeSpaceGB GB"
    exit 0
}
