

##########################
#Developed by Rhys Saddul#
##########################

# Map variables
$SiteURL = "https://uxbridgecollegeacuk.sharepoint.com/sites/UX-Portal"
$featureScope = "Site"	#Scope of feature 
$featureId = "f6924d36-2fa8-4f0b-b16d-06b7250180fa"	#SharePoint List Rating Features 
$AdminURL = "https://uxbridgecollegeacuk-admin.sharepoint.com"

# Connect to SharePoint online
#Connect-SPOService -Url $AdminURL

#Connect to SharePoint site
Connect-PnPOnline -Url $siteURL -UseWebLogin
 
#Get Feature from SharePoint site
$spacesFeature = Get-PnPFeature -Scope $featureScope -Identity $featureId
 
#Check if feature is already activated or not
if($spacesFeature.DefinitionId -eq $null) {  
    Write-host "Activating Feature ($featureId)..." 
	
    #Activate the Feature
    Enable-PnPFeature -Scope Site -Identity $FeatureId -Force
 
    Write-host -f Green "Feature ($featureId) has been activated Successfully!"
}
else {
    Write-host "Feature ($featureId) is already active on this site!"
}