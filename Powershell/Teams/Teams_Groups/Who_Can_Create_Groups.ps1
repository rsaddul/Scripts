# Developed by Rhys Saddul

# https://learn.microsoft.com/en-us/microsoft-365/solutions/manage-creation-of-groups?view=o365-worldwide#step-2-run-powershell-commands
# Install-Module Microsoft.Graph.Beta.Identity.DirectoryManagement
# Install-Module Module Microsoft.Graph.Beta.Groups

Import-Module Microsoft.Graph.Beta.Identity.DirectoryManagement
Import-Module Microsoft.Graph.Beta.Groups

# Connect-MgGraph -Scopes "Directory.ReadWrite.All", "Group.Read.All", "Group.ReadWrite.All"

$setting = Get-MgBetaDirectorySetting | Where-Object -Property DisplayName -EQ "Group.Unified"

if ($setting -eq $null) {
    Write-Host "GroupCreationAllowedGroupId not found" -ForegroundColor Red
} else {
    $groupId = $setting.Values | Where-Object {$_.Name -eq "GroupCreationAllowedGroupId"} | Select-Object -ExpandProperty Value

    if (![string]::IsNullOrEmpty($groupId)) {
        $group = Get-MgBetaGroup -GroupId $groupId
        Write-Host "Group name: $($group.DisplayName)" -ForegroundColor Green
    } else {
        Write-Host "GroupCreationAllowedGroupId is not set in the policy." -ForegroundColor Yellow
    }
}
