#Run the below script on the Target Tenant 

# Connect to Target Tenant
Connect-ExchangeOnline

Remove-MigrationEndpoint -identity "Cross-Tenant Migration"

#Disconnect-ExchangeOnline
