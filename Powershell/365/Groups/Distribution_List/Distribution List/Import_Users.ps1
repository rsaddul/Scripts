Add-Type -AssemblyName System.Windows.Forms

# Create a function to display a message box
function Show-MessageBox {
    param (
        [string]$Message,
        [string]$Title,
        [System.Windows.Forms.MessageBoxButtons]$Buttons,
        [System.Windows.Forms.MessageBoxIcon]$Icon
    )

    [System.Windows.Forms.MessageBox]::Show($Message, $Title, $Buttons, $Icon)
}

# Prompt the user for action
$choice = [System.Windows.Forms.MessageBox]::Show(
    "Do you want to create a new mail-enabled security group and add users (Yes) or add users to an existing group (No)?",
    "Group Action",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

if ($choice -eq [System.Windows.Forms.DialogResult]::Yes) {
    # Create a new security group and add users
    $GroupName = Read-Host "Enter the name for the new mail-enabled security group"
    $GroupAlias = Read-Host "Enter an alias for the group (used in the primary SMTP address)"

    # Check if the group already exists
    if (Get-ADGroup -Filter {Name -eq $GroupName}) {
        Show-MessageBox "Group '$GroupName' already exists." "Group Creation Error" [System.Windows.Forms.MessageBoxButtons]::OK [System.Windows.Forms.MessageBoxIcon]::Error
    }
    else {
        # Create the security group
        New-DistributionGroup -Name $GroupName -Alias $GroupAlias -Type Security

        # Enable mail for the group
        Enable-DistributionGroup -Identity $GroupName -Alias $GroupAlias -PrimarySmtpAddress "$GroupAlias@yourdomain.com"

        $CSVFilePath = Read-Host "Enter the path to the CSV file containing user data"
        $CSVData = Import-Csv -Path $CSVFilePath

        foreach ($User in $CSVData) {
            Add-DistributionGroupMember -Identity $GroupName -Member $User.Username
        }

        Show-MessageBox "Group '$GroupName' created, and users added." "Group Created" [System.Windows.Forms.MessageBoxButtons]::OK [System.Windows.Forms.MessageBoxIcon]::Information
    }
}
elseif ($choice -eq [System.Windows.Forms.DialogResult]::No) {
    # Add users to an existing security group
    $GroupName = Read-Host "Enter the name of the existing mail-enabled security group"

    if (Get-ADGroup -Filter {Name -eq $GroupName}) {
        $CSVFilePath = Read-Host "Enter the path to the CSV file containing user data"
        $CSVData = Import-Csv -Path $CSVFilePath

        foreach ($User in $CSVData) {
            Add-DistributionGroupMember -Identity $GroupName -Member $User.Username
        }

        Show-MessageBox "Users added to group '$GroupName'." "Users Added" [System.Windows.Forms.MessageBoxButtons]::OK [System.Windows.Forms.MessageBoxIcon]::Information
    }
    else {
        Show-MessageBox "Group '$GroupName' does not exist." "Group Not Found" [System.Windows.Forms.MessageBoxButtons]::OK [System.Windows.Forms.MessageBoxIcon]::Error
    }
}
else {
    Show-MessageBox "Invalid choice. Please select Yes or No." "Invalid Choice" [System.Windows.Forms.MessageBoxButtons]::OK [System.Windows.Forms.MessageBoxIcon]::Error
}
