Connect-MicrosoftTeams

# https://learn.microsoft.com/en-us/microsoftteams/block-inbound-calls

# Returns the inbound block number patterns and the inbound exempt number patterns parameters for the global blocked number list. 
#This cmdlet also returns whether blocking has been Enabled
Get-CsTenantBlockedCallingNumbers

# Allows you to specify whether the global tenant blocked calls are turned on or off at the tenant level.
Set-CsTenantBlockedCallingNumbers 

# Returns a list of all blocked number patterns added to the tenant list including Name, Description, Enabled (True/False), and Pattern.
Get-CsInboundBlockedNumberPattern


# Adds a blocked number pattern to the tenant list.
New-CsInboundBlockedNumberPattern

# Removes a blocked number pattern from the tenant list.
Remove-CsInboundBlockedNumberPattern -Identity "BlockAutomatic4"

# Modifies one or more parameters of a blocked number pattern in the tenant list.
Set-CsInboundBlockedNumberPattern 

# Tests whether calls from a given phone number will be blocked.
Test-CsInboundBlockedNumberPattern -PhoneNumber +447828783941


# Blocks call coming from specific number using number pattern
New-CsInboundBlockedNumberPattern -Name "BlockAutomatic5" -Enabled $True -Description "Avoid Unwanted Automatic Call" -Pattern "^\+447828783941"


Remove-CsInboundExemptNumberPattern -Identity "BlockAutomatic4"