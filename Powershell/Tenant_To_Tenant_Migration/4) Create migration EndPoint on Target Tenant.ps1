#Create migration EndPoint on Target Tenant

# Target Tenant
Connect-ExchangeOnline

# Enable customization if tenant is dehydrated
$dehydrated=Get-OrganizationConfig | select isdehydrated
if ($dehydrated.isdehydrated -eq $true) {Enable-OrganizationCustomization}
$AppId = "05734c24-7d71-4487-9603-92e5c6aef316"
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AppId, (ConvertTo-SecureString -String "p5C8Q~p5X1.nwIb5s_ZWEg8ZUOAY729cutr62cGV" -AsPlainText -Force)
New-MigrationEndpoint -RemoteServer outlook.office.com -RemoteTenant "mintsupport.onmicrosoft.com" -Credentials $Credential -ExchangeRemoteMove:$true -Name "Cross-Tenant Migration" -ApplicationId $AppId

#get-MigrationEndpoint

#Disconnect-ExchangeOnline