# Here's a PowerShell script that reads a CSV file with a column named "username" and adds each user to a specified security group in Active Directory:

# Set the path to the CSV file
$csvPath = "C:\test.csv"

# Set the name of the security group in Active Directory
$groupName = "UX Security - Engineering Students"

# Get the Active Directory group object
$group = Get-ADGroup $groupName

# Read the CSV file and add each user to the security group
Import-Csv $csvPath | ForEach-Object {
    $username = $_.username
    Add-ADGroupMember $group -Members $username
}
