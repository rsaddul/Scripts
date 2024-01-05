# Define the list of OUs to search
$OUs = @(
    "OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=MIS,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=Unsure,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=Staff_Laptops,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=Academy,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=DESMOND,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=ELTFS,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=ENGTI,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=ENMA,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=Trolley1,OU=ENMA,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=Trolley2,OU=ENMA,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=ESOL,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=HSCCS,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=Learning_Support,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=LS_Trolley_01,OU=Learning_Support,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=Student_loaned,OU=Learning_Support,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=LRC,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=Dynabook_Trolley_01,OU=LRC,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=Dynabook_Trolley_02,OU=LRC,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=ELTFS,OU=LRC,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=Northwick Hospital,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc"
    "OU=STPS,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=Dynabook,OU=STPS,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "OU=HP 15,OU=STPS,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc",
    "CN=UX-STPS-57,OU=STPS,OU=Student Laptop Trolleys,OU=UX,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc"
)

# Empty array to store results
$results = @()

# Loop through each OU  and query computer objects
ForEach ($OU in $OUs ) {
$Computers = Get-ADComputer -Filter * -SearchBase $OU

# Loop through each computer and add it to the results array
ForEach ($Computer in $Computers) {

# Add a custom object to the reuslts array with the computer name and enabled status
    $Result = [PSCustomObject]@{
        'Name'     = $Computer.Name
        'Enabled'  = $Computer.Enabled
        }

$Results += $Result

    }

}

# Export the results to a CSV file
$Results | Export-CSV -Path "c:\Old_Structure_UX.csv" -NoTypeInformation