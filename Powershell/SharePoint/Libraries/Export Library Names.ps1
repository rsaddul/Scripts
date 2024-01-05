#Config Variables
$SiteURL = "https://uxbridgecollegeacuk.sharepoint.com/sites/UX-Portal"
$OutputFile = "C:\output.csv"

try {
    # Connect to SharePoint Online interactively
    Connect-PnPOnline -Url $SiteURL -Interactive
    
    # Get all lists
    $Lists = Get-PnPList
    
    # Filter document libraries and create a collection of custom objects with "Name" property
    $DocumentLibraryNames = foreach ($List in $Lists) {
        if ($List.BaseTemplate -eq 101) {  # DocumentLibrary base template ID is 101
            [PSCustomObject]@{
                Name = $List.Title
            }
        }
    }
    
    # Select only the "Name" property and export to CSV
    $DocumentLibraryNames | Select-Object -Property Name | Export-Csv -Path $OutputFile -NoTypeInformation
    
    Write-Host "Export completed successfully!"
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}