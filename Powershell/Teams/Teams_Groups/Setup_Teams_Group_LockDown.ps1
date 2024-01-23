# Developed by https://learn.microsoft.com/en-us/microsoft-365/solutions/manage-creation-of-groups?view=o365-worldwide

#  This script is used to setup a security group to have access to create Teams Groups

# Install-module AzureADPreview

# Connect to Azure Active Directory
Connect-AzureAD

# Specify the name of the security group and whether group creation is allowed
$GroupName = "Teams Group Creation"
$AllowGroupCreation = "False"

# Connect to Azure AD again (not necessary if already connected)

# Retrieve the ID of the directory setting for Unified Groups
$settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id

# Check if the directory setting exists, create it if not
if (!$settingsObjectID) {
    $template = Get-AzureADDirectorySettingTemplate | Where-object { $_.displayname -eq "group.unified" }
    $settingsCopy = $template.CreateDirectorySetting()
    New-AzureADDirectorySetting -DirectorySetting $settingsCopy
    $settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
}

# Retrieve the existing directory setting
$settingsCopy = Get-AzureADDirectorySetting -Id $settingsObjectID

# Set the value for EnableGroupCreation
$settingsCopy["EnableGroupCreation"] = $AllowGroupCreation

# If $GroupName is provided, set the GroupCreationAllowedGroupId to the object ID of the specified group
if ($GroupName) {
    $settingsCopy["GroupCreationAllowedGroupId"] = (Get-AzureADGroup -SearchString $GroupName).objectid
} else {
    # If $GroupName is not provided, set the GroupCreationAllowedGroupId to the specified value
    $settingsCopy["GroupCreationAllowedGroupId"] = $GroupName
}

# Update the directory setting
Set-AzureADDirectorySetting -Id $settingsObjectID -DirectorySetting $settingsCopy

# Display the values of the updated directory setting
(Get-AzureADDirectorySetting -Id $settingsObjectID).Values
