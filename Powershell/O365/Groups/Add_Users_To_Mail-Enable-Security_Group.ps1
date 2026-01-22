
# Prompt to ensure variables have been set up correctly prior to running the script
$dialogResult = [System.Windows.Forms.MessageBox]::Show("Have you set the variable for the output file path?", "Variable Setup", "YesNo", "Question")
if ($dialogResult -eq "Yes") {
    Write-Host "User confirmed variables have been set. Proceeding with the script." -ForegroundColor Green
} else {
    Write-Host "User confirmed variables have not been set. Exiting the script." -ForegroundColor Red
    return
}
 
# Prompt the user for the group name
$GroupName = "MESG_EDUS_All_Students@eduthing.co.uk"
$CSVFilePath = "C:\Users\RhysSaddul\OneDrive - eduthing\Desktop\SMH\Intune_SharePoint\Add_Users_To_Mail-Enable-Security_Group.csv"

# Connect to Exchange Online
Connect-ExchangeOnline

# Check if the group exists in Exchange Online
$existingGroup = Get-DistributionGroup -Identity $GroupName
 
if ($existingGroup){
if ($existingGroup.RecipientTypeDetails -eq "MailUniversalSecurityGroup") {
    # Import user data from CSV and add them to the group
    $CSVData = Import-Csv -Path $CSVFilePath
 
    foreach ($User in $CSVData) {
        Add-DistributionGroupMember -Identity $GroupName -Member $User.UserPrincipalName
        Write-Host "User '$($User.UserPrincipalName)' added to mail-enabled security group '$GroupName'." -ForegroundColor Green
    }
 
    Write-Host "All users added to mail-enabled security group '$GroupName'." -ForegroundColor Green
} else {
   Write-Host "'$GroupName' exists but is not a mail-enabled security group." -ForegroundColor Yellow
   }
}else {
    Write-Host "Mail-enabled security group '$GroupName' does not exist." -ForegroundColor Red
}
 
# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false