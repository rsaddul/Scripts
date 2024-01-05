# Variables
$folderPath = "C:\HRUC\Scripts\IT_Support"
$sourcePath = $PSScriptRoot
$destinationPath = "C:\HRUC\Scripts\IT_Support"
$hidePath = "C:\HRUC"
$startupDestinationPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"

# Functions

function Create-Folder {
    param (
        [string]$folderPath
    )
    
    if (-not (Test-Path -Path $folderPath -PathType Container)) {
        New-Item -Path $folderPath -ItemType Directory
        Write-Host "Folder created."
    } else {
        Write-Host "Folder already exists."
    }
}

function Hide-Folder {
    param (
        [string]$folderPath
    )
    
    $cmdCommand = "cmd /c attrib +h `"$folderPath`""
    Invoke-Expression -Command $cmdCommand
    Write-Host "Folder hidden."
}

function Copy-Files {
    param (
        [string]$sourcePath,
        [string]$destinationPath
    )
    
    $filesToCopy = Get-ChildItem -Path $sourcePath
    foreach ($file in $filesToCopy) {
        $destinationFile = Join-Path -Path $destinationPath -ChildPath $file.Name
        Copy-Item -Path $file.FullName -Destination $destinationFile -Force
        Write-Host "Copied $($file.Name) to $($destinationFile)"
    }
}

# Actions using functions

Create-Folder -folderPath $folderPath
Hide-Folder -folderPath $hidePath
Copy-Files -sourcePath $sourcePath -destinationPath $destinationPath

# Copy HRUC InfoApp.lnk to system's Startup folder
$SupportIcon = Get-ChildItem -Path $sourcePath | Where-Object { $_.Name -like "*HRUC_InfoApp.lnk*" }
Copy-Item -Path $SupportIcon.FullName -Destination $startupDestinationPath -Force
