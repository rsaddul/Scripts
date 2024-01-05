# Developed by Rhys Saddul

# This script will check a list of computer objects you export from AD to see if they exist on Intune Endpoint.

# Set the path to the CSV file containing the computer names
$computersFilePath = "C:\Intune_Devices.csv"

# Read in the computer names from the CSV file
$computers = Import-Csv $computersFilePath | Select-Object -ExpandProperty Name

# Authenticate with Microsoft Graph
Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All"

# Array to store computer names that do not exist in Intune Devices section
$notInIntune = @()

# Loop through each computer and check if it exists in the Intune Devices section of the Endpoint Manager admin center
foreach ($computer in $computers) {
    $device = Get-MgDeviceManagementManagedDevice -Filter "deviceName eq '$computer'" -ErrorAction SilentlyContinue
    if ($device) {
        Write-Host "$computer exists in the Intune Devices section of the Endpoint Manager admin center." -ForegroundColor Green
    } else {
        Write-Host "$computer does not exist in the Intune Devices section of the Endpoint Manager admin center." -ForegroundColor Red
        $notInIntune += $computer
    }
}

# Export the list of computer names that do not exist in Intune Devices section to a CSV file
$notInIntune | Select-Object @{Name='ComputerName';Expression={$_}} | Export-Csv -Path "C:\Not_Intune.csv"