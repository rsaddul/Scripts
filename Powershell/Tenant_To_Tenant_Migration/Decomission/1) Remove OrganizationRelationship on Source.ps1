# Connect to Source Tenant
Connect-ExchangeOnline

Remove-OrganizationRelationship -Identity "From Source to Target"

#Disconnect-ExchangeOnline 
