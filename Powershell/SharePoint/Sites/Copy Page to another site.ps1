#Parameters
$SourceSiteURL = "https://uxbridgecollegeacuk.sharepoint.com/sites/Digital_Inform"
$DestinationSiteURL = "https://uxbridgecollegeacuk.sharepoint.com/sites/Digital_Information/"
$PageName =  "Home.aspx"
  
#Connect to Source Site
Connect-PnPOnline -Url $SourceSiteURL -Interactive
  
#Export the Source page
$TempFile = [System.IO.Path]::GetTempFileName()
Export-PnPPage -Force -Identity $PageName -Out $TempFile
  
#Import the page to the destination site
Connect-PnPOnline -Url $DestinationSiteURL -Interactive
Invoke-PnPSiteTemplate -Path $TempFile