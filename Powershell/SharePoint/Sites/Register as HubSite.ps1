##########################
#Developed by Rhys Saddul#
##########################

# Map variables
$AdminURL = "https://uxbridgecollegeacuk-admin.sharepoint.com"
$SiteURL = "https://uxbridgecollegeacuk.sharepoint.com/sites/HRUC-Staff"

# Connect to SharePoint online
Connect-SPOService -Url $AdminURL

# Register SharePoint site as a Hub Site
Register-SPOHubSite -Site $SiteURL -Principals $null