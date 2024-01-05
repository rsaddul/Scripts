# Import the Active Directory module
Import-Module ActiveDirectory

# Specify the path to the CSV file
$csvPath = "C:\Users\rsaddul\OneDrive - HCUC\Documents\test1.csv"

# Specify the target OU
$targetOUFormat = "OU=Staff,OU=Users,OU={0},OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"

# Specify the domain controller
$domainController = "UX-DC-01.resource.uc"

# Specify the default password for new user accounts
$defaultPassword = ConvertTo-SecureString -AsPlainText "pleasechangeyourpassword" -Force

# Read the CSV file
$users = Import-Csv -Path $csvPath

# Loop through each row in the CSV
foreach ($user in $users) {
    # Assign values from the CSV columns to variables
    $staffID = $user."Staff ID"
    $forename = $user.Forename
    $surname = $user.Surname
    $jobTitle = $user."Job Title"
    $department = $user.Department
    $email = "$($forename.ToLower()).$($surname.ToLower())@hruc.ac.uk"
    $room = $user.Room
    $ddi = $user.DDI
    $extension = $user.Extension
    $location = $user.Location
    
    # Create the username
    $username = $forename[0].ToString().ToLower() + $surname.ToLower()
    
    # Set the OU and user group based on the location
    switch ($location) {
        "Uxbridge" {
            $ou = $targetOUFormat -f "UX"
            $userGroup = "UX Security - All Staff"
            break
        }
        "Hayes" {
            $ou = $targetOUFormat -f "HY"
            $userGroup = "HY Security - All Staff"
            break
        }
        "Harrow Weald" {
            $ou = $targetOUFormat -f "HW"
            $userGroup = "HW Security - All Staff"
            break
        }
        "Harrow on the Hill" {
            $ou = $targetOUFormat -f "HH"
            $userGroup = "HH Security - All Staff"
            break
        }
        default {
            Write-Warning "Unknown location: $location. Skipping user account creation for $forename $surname."
            continue
        }
    }
    
    # Create a new user account in Active Directory
    $newUserParams = @{
        SamAccountName = $username
        UserPrincipalName = "$($forename.ToLower()).$($surname.ToLower())@hruc.ac.uk"
        Name = "$forename $surname"
        DisplayName = "$forename $surname"
        GivenName = $forename
        Surname = $surname
        Description = $department
        EmailAddress = $email
        Title = $jobTitle
        Office = $room
        OfficePhone = $ddi
        EmployeeID = $staffID
        Company = $location
        OtherAttributes = @{extensionAttribute11 = $staffID}
        Enabled = $true
        PasswordNeverExpires = $false
        ChangePasswordAtLogon = $true
        AccountPassword = $defaultPassword
    }

    # Create the user account in the target OU using the specified domain controller
    $newUser = New-ADUser @newUserParams -PassThru -Path $ou -Server $domainController

    # Output the created user account details
    Write-Host "User account created for $forename $surname"
    
    # Add the user to the specified user group
    Add-ADGroupMember -Identity $userGroup -Members $newUser
}
