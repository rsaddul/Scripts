# Define the list of OUs to search
$OUs = @(
    "OU=Intune,OU=Mobile,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc",
    "OU=Intune,OU=Mobile,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc",
    "OU=Intune,OU=Mobile,OU=Devices,OU=HY,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc",
    "OU=Intune,OU=Mobile,OU=Devices,OU=UX,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc",
    "OU=New Intune Devices,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc",
    "OU=Intune Devices,OU=HCUC,DC=resource,DC=uc"    
)

# Empty array to store results
$results = @()

# Loop through each OU and query computer objects
ForEach ($OU in $OUs ) {
    $Computers = Get-ADComputer -Filter * -SearchBase $OU

    # Loop through each computer and add a custom object to the results array with the computer name
    ForEach ($Computer in $Computers) {
        $Result = [PSCustomObject]@{
            'Name'     = $Computer.Name
        }

        $Results += $Result
    }
}

# Export the results to a CSV file
$Results | Export-CSV -Path "c:\Intune_Devices.csv" -NoTypeInformation
