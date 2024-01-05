# Variables 
$DeviceId = "3666c74a-de83-4c76-83c6-22a9c95ba57d"
$DisplayName = "Rhys-test"
$OS = "Windows"
$OSVersion = "10.0.19044.1466"

#Get-MgDevice -DeviceId 3666c74a-de83-4c76-83c6-22a9c95ba57d
#Connect-MgGraph -Scopes "User.Read.all","Application.Read.All"

Import-Module Microsoft.Graph.Identity.DirectoryManagement

$params = @{
	AccountEnabled = $false
	AlternativeSecurityIds = @(
		@{
			Type = 2
			Key = [System.Text.Encoding]::ASCII.GetBytes("base64Y3YxN2E1MWFlYw==")
		}
	)
	DeviceId = $DeviceId 
	DisplayName = $DisplayName
	OperatingSystem = $OS
	OperatingSystemVersion = $OSVersion 
}

New-MgDevice -BodyParameter $params






