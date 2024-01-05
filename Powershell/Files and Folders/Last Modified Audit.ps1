# set the path to the directory you want to search
$directory = "C:\example\directory"

# set the year you want to search for
$year = "2022"

# create a new array to hold the file info
$fileInfo = @()

# get all files and folders recursively
$items = Get-ChildItem -Path $directory -Recurse

# loop through each item and get the last modified date
foreach ($item in $items) {
    # check if the item is a file
    if ($item.PSIsContainer -eq $false) {
        # check if the last modified year matches the year we're searching for
        if ($item.LastWriteTime.Year -eq $year) {
            # add the file name and last modified date to the array
            $fileInfo += New-Object PSObject -Property @{
                FileName = $item.Name
                LastModified = $item.LastWriteTime
            }
        }
    }
}

# output the file info to the console
$fileInfo | Format-Table

# or output the file info to a CSV file
$fileInfo | Export-Csv -Path "C:\example\output.csv" -NoTypeInformation
