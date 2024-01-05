#Variables for Admin Center and Site Collection URL
$AdminCenterURL = "https://uxbridgecollegeacuk-admin.sharepoint.com/"
$SiteURL="https://uxbridgecollegeacuk.sharepoint.com/sites/ITServices"
 
#Connect to SharePoint Online
Connect-SPOService -url $AdminCenterURL 
 
#Disable DenyAddAndCustomizePages Flag
Set-SPOSite $SiteURL -DenyAddAndCustomizePages $False


#Read more: https://www.sharepointdiary.com/2017/08/sharepoint-online-save-list-as-template-missing.html#ixzz7dXMfMVg7