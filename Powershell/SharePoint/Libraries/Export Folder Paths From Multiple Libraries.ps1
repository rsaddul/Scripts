# Config Variables
$SiteURL = "https://uxbridgecollegeacuk.sharepoint.com/sites/UX-Portal"
$ListNames = @(
    "Apprenticeship & Skills",
    "Business",
    "Computing",
    "ELT, Foundation & Learning Support",
    "Engineering - Mechanical & Electronics",
    "Engineering - Technology & Innovation",
    "English & Maths",
    "Hair, Beauty, Hospitality, Early Years & Performing Arts",
    "Health & Social Care, Creative Arts",
    "Sixth Form",
    "Sports, Travel & Public Services",
    "Teacher Training",
    "Technical Apprenticeship School"

)

Try {
    # Connect to PnP Online
    Connect-PnPOnline -Url $SiteURL -Interactive

    # Initialize an empty array to store folder details
    $FolderDetails = @()

    # Loop through each list name
    foreach ($ListName in $ListNames) {
        # Get all list items in the list
        $ListItems = Get-PnPListItem -List $ListName -PageSize 500

        # Filter list items to retrieve only folders
        $Folders = $ListItems | Where-Object { $_.FileSystemObjectType -eq "Folder" }

        # Loop through each folder and retrieve its details
        foreach ($Folder in $Folders) {
            # Retrieve folder path from the FolderPath property
            $FolderPath = $Folder["FileRef"]

            # Create a custom object with folder details
            $FolderDetail = [PSCustomObject]@{
                "ListName" = $ListName
                "FolderPath" = $FolderPath
            }

            # Add the folder details to the array
            $FolderDetails += $FolderDetail
        }
    }

    # Display the total number of folders
    Write-Host "Total Number of Folders in the Lists:" $FolderDetails.Count

    # Export folder details to CSV
    $FolderDetails | Export-Csv -Path "C:\Test.csv" -NoTypeInformation

    Write-Host "Export completed successfully!"
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
