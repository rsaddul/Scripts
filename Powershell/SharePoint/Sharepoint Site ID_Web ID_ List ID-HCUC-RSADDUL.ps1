#Config Variable
$SiteURL = "https://uxbridgecollegeacuk.sharepoint.com/sites/HA-Portal"
$ListTitle = "Business Hair Beauty  Sport"

#Install PNP
If (Get-Module -Name "PnP.PowerShell" -ListAvailable)
{Write-Host "PNP Installed"-ForegroundColor Magenta
}
Else
{
Write-Host "Missiing PNP, will not install"
Install-Module -Name "PnP.PowerShell"
}

#Connect to PnP Online
Connect-PnPOnline -URL $SiteURL -Interactive

#Start-Transcript -Path "C:\Users\Rhys's Desktop\Desktop\Test\transcript0.txt" -NoClobber
 
#Get the site collection with ID property
$Site = Get-PnPSite -Includes ID

#Get Site ID
Write-host -f Green "Site ID:"$Site.Id

#Get the Subsite with ID property
$Web = Get-PnPWeb -Includes ID
 
#Get Web ID
Write-host -f Yellow "Web ID: " $Web.Id

#Get list by GUID
$List = Get-PnPList -Identity $ListTitle
 
#Get List ID
Write-host -f Red "List ID:" $List.Id

#Stop-Transcript