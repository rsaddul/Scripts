
Function AzureADAdminCheck {
    #---- Define the local Administrators group name ----#
    $groupName = "Administrators"
    
    #---- Get all members of the Administrators group ----#
    $groupMembers = Get-LocalGroupMember -Group $groupName
    
    #---- Filter member accounts starting with 'AzureAD\' ----#
    $azureAdMembers = $groupMembers | Where-Object { $_.Name -like "AzureAD\*" }
    

    # Check and log AzureAD members
    if ($azureAdMembers.Count -gt 0) {
        $azureAdLogging = ($azureAdMembers | Select-Object -ExpandProperty Name) -join ", "
    }
    
    #----  Remove each AzureAD\ user from the Administrators group ----#
    foreach ($member in $azureAdMembers) {
        Remove-LocalGroupMember -Group $groupName -Member $member.Name -ErrorAction SilentlyContinue        
    }
}

Function LocalAdminChecks {
    #---- Filter all local users excluding specific accounts ----#
    $localUsers = Get-LocalUser | Where-Object {
        $_.Name -notin @("IntuneAdmin", "DefaultAccount", "Guest", "WDAGUtilityAccount") -and $_.Enabled -eq $true
    }
    

    #---- Check and log local users ----#
    if ($localUsers.Count -gt 0) {
        $localUserLogging = ($localUsers | Select-Object -ExpandProperty Name) -join ", "
    }
    
    #---- Disable each local user apart from IntuneAdmin ----#
    foreach ($localUser in $localUsers) {
        Disable-LocalUser -Name $localUser.Name -ErrorAction SilentlyContinue    
    }
}

Function Logging {
    # $localUserLogging and $azureAdLogging with a separator
    $combinedLogging = "$localUserLogging; $azureAdLogging"

    # Add the combined value to the registry
    REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\CentraStage /v Custom14 /t REG_SZ /d "$combinedLogging" /f
}


AzureADAdminCheck
LocalAdminChecks
Logging