# Developed by: Rhys Saddul

# This script bulk-renames files in a folder (and all its subfolders) by removing - Copy from the filename.

# Set the folder path
$folderPath = "C:\Users\RhysSaddul\OneDrive - eduthing\Documents\Migrations\Intune\Intune_Manager\"

Get-ChildItem -Path $folderPath -File -Recurse | Where-Object { $_.Name -like "*- Copy*" } | ForEach-Object {
    $originalName = $_.Name
    $newName = $originalName -replace '\s*- Copy', ''  # Remove " - Copy"
    $newPath = Join-Path -Path $_.DirectoryName -ChildPath $newName

    # Rename the file
    Rename-Item -Path $_.FullName -NewName $newPath
    Write-Host "Renamed '$originalName' to '$newName'"
}