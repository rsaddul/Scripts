<#
Developed by: Rhys Saddul

Overview: This will create an Outbound Anti-Spam Policy called [Custom Outbound] - Migration Policy. This will be targeted to the specified domain. 
This policy will have fowarding enabled.

#>

# Base Variables
$ruleName = "[Custom Outbound] - Migration Rule"
$domain = "brightonhill.hants.sch.uk"  # Replace with domain suffix

# Prompt to ensure variables have been set up correctly prior to running the script
$dialogResult = [System.Windows.Forms.MessageBox]::Show("Have you set the variables?", "Variable Setup", "YesNo", "Question")
if ($dialogResult -eq "Yes") {
    Write-Host "User confirmed variables have been set. Proceeding with the script." -ForegroundColor Green
} else {
    Write-Host "User confirmed variables have not been set. Exiting the script." -ForegroundColor Red
    return
}

# Check if ExchangeOnlineManagement module is installed
if (-not (Get-Module -Name ExchangeOnlineManagement -ListAvailable)) {
    Write-Host "ExchangeOnlineManagement module is not installed. Please install the module before proceeding." -ForegroundColor Red
    exit
}

# Connect to Exchange Online
Connect-ExchangeOnline -ShowBanner:$false

# Step 1: Define the outbound spam filter policy settings
$filterPolicyName = "[Custom Outbound] - Migration Policy"
$bccSuspiciousOutboundMail = $false
$notifyOutboundSpam = $false
$recipientLimitExternalPerHour = 0
$recipientLimitInternalPerHour = 0
$recipientLimitPerDay = 0
$actionWhenThresholdReached = "BlockUserForToday"
$autoForwardingMode = "On"

# Check if the outbound spam filter policy already exists
$existingPolicy = Get-HostedOutboundSpamFilterPolicy -Identity $filterPolicyName -ErrorAction SilentlyContinue

if ($null -eq $existingPolicy) {
    # Create the outbound spam filter policy
    New-HostedOutboundSpamFilterPolicy -Name $filterPolicyName `
      -BccSuspiciousOutboundMail $bccSuspiciousOutboundMail `
      -NotifyOutboundSpam $notifyOutboundSpam `
      -RecipientLimitExternalPerHour $recipientLimitExternalPerHour `
      -RecipientLimitInternalPerHour $recipientLimitInternalPerHour `
      -RecipientLimitPerDay $recipientLimitPerDay `
      -ActionWhenThresholdReached $actionWhenThresholdReached `
      -AutoForwardingMode $autoForwardingMode | Out-Null

    # Create the outbound spam filter rule
    New-HostedOutboundSpamFilterRule -Name $ruleName `
      -HostedOutboundSpamFilterPolicy $filterPolicyName `
      -SenderDomainIs $domain | Out-Null

    Write-Host "Outbound spam filter policy and rule created successfully." -ForegroundColor Green
} else {
    Write-Host "Outbound spam filter policy already exists. Skipping creation." -ForegroundColor Yellow
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -ShowBanner:$false
