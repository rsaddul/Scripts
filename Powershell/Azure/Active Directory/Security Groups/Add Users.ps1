###########################
# Devleoped by Rhys Saddul #
###########################

# This script will add users to Azure AD Security Groups


# Connect to commandlet	
Connect-AzureAD

# Import the data from CSV file and assign it to variable
$Users = Import-Csv "C:\Temp\Users.csv" -Delimiter ","


# Specify target group where the users will be added to
# You can add the distinguishedName of the group. For example: CN=Pilot,OU=Groups,OU=Company,DC=exoip,DC=local
$Group = "HCUC IT Security - Teams Groups"
   
 foreach($user in $Users) {
     $AzureADUser = Get-AzureADUser -Filter "UserPrincipalName eq '$($user.UPN)'"
     if($AzureADUser -ne $null) {
         try {
             $AzureADGroup = Get-AzureADGroup -Filter "DisplayName eq '$Group'" -ErrorAction Stop
             $isUserMemberOfGroup = Get-AzureADGroupMember -ObjectId $AzureADGroup.ObjectId -All $true | Where-Object {$_.UserPrincipalName -like "*$($AzureADUser.UserPrincipalName)*"}
             if($isUserMemberOfGroup -eq $null) {
                 Add-AzureADGroupMember -ObjectId $AzureADGroup.ObjectId -RefObjectId $AzureADUser.ObjectId -ErrorAction Stop
             }
         }
         catch {
             Write-Output "Azure AD Group does not exist or insufficient right"
         }
     }
     else {
         Write-Output "User does not exist"
     }
 }
