# Source Tenant
Connect-ExchangeOnline

# Prepare Source tenant
# Enable customization if tenant is dehydrated

$targetTenantId="9abfd72a-18ef-4aaf-8553-b839c681ead9"
$appId="05734c24-7d71-4487-9603-92e5c6aef316"
$scope="MintToEduthingMigration@mint-group.co.uk"
$existingOrgRel = $orgrels | ?{$_.DomainNames -like $targetTenantId}
If ($null -ne $existingOrgRel)
{
Set-OrganizationRelationship $existingOrgRel.Name -Enabled:$true -MailboxMoveEnabled:$true -MailboxMoveCapability RemoteOutbound -OAuthApplicationId $appId -MailboxMovePublishedScopes $scope
}
If ($null -eq $existingOrgRel)
{
New-OrganizationRelationship "From Source to Target" -Enabled:$true -MailboxMoveEnabled:$true -MailboxMoveCapability RemoteOutbound -DomainNames $targetTenantId -OAuthApplicationId $appId -MailboxMovePublishedScopes $scope
}

#Disconnect-ExchangeOnline
