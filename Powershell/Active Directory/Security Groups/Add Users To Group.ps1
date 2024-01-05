# Import AD Module
Import-Module ActiveDirectory

#Log Folder
$LogFolder = "C:\logs"

# Import the data from CSV file and assign it to variable
$Users = Import-Csv "C:\test.csv"

#Array Logs
$failedUsers = @()
$usersAlreadyExist =@()
$successUsers = @()

# Specify target group where the users will be added to
# You can add the distinguishedName of the group. For example: CN=Pilot,OU=Groups,OU=Company,DC=exoip,DC=local
$Group = "UX Security - Engineering Students" 

foreach ($User in $Users) {
    # Retrieve UPN
    $UPN = $User.UserPrincipalName

    # Retrieve UPN related SamAccountName
    $ADUser = Get-ADUser -Filter "UserPrincipalName -eq '$UPN'" | Select-Object SamAccountName

    # User from CSV not in AD
    if ($ADUser -eq $null) {
        Write-Host "$UPN does not exist in AD" -ForegroundColor Red
        $failedUsers += $UPN
    }
    else {
        # Retrieve AD user group membership
        $ExistingGroups = Get-ADPrincipalGroupMembership $ADUser.SamAccountName | Select-Object Name

        # User already member of group
        if ($ExistingGroups.Name -eq $Group) {
            Write-Host "$UPN already exists in $Group" -ForeGroundColor Yellow
            $usersAlreadyExist += $UPN
        }
        else {
            # Add user to group
            Add-ADGroupMember -Identity $Group -Members $ADUser.SamAccountName -WhatIf
            Write-Host "Added $UPN to $Group" -ForeGroundColor Green
            $successUsers += $UPN
        }
    }

    Write-verbose "Writing logs"
    $failedUsers | out-file -FilePath "$LogFolder\FailedUsers.log" -Force -Verbose
    $usersAlreadyExist | out-file -FilePath "$LogFolder\usersAlreadyExist.log" -Force -Verbose
    $successUsers | out-file "$LogFolder\successUsers .log" -Force -Verbose
}