# Create a new organization relationship from Target to Source tenant

# Connect to Target Tenant
Connect-ExchangeOnline

$sourceTenantId="dc2c8fb7-fa7e-426c-8125-7db33ea30c66"
$orgrels=Get-OrganizationRelationship
$existingOrgRel = $orgrels | ?{$_.DomainNames -like $sourceTenantId}
If ($null -ne $existingOrgRel)
{
    Set-OrganizationRelationship $existingOrgRel.Name -Enabled:$true -MailboxMoveEnabled:$true -MailboxMoveCapability Inbound
}
If ($null -eq $existingOrgRel)
{
    New-OrganizationRelationship "From Target to Source" -Enabled:$true -MailboxMoveEnabled:$true -MailboxMoveCapability Inbound -DomainNames $sourceTenantId
}

#Get-OrganizationRelationship | Format-List
#Disconnect-ExchangeOnline