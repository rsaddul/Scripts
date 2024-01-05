# Connect to Target Tenant
Connect-ExchangeOnline

Remove-OrganizationRelationship -Identity "From Target to Source"

#Disconnect-ExchangeOnline 
