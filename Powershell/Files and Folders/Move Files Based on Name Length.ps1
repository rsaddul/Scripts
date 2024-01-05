$sourcePath = "C:\TEST\"
$destinationPath = "C:\Other\"

$files = Get-ChildItem -Path $sourcePath | Where-Object { $_.Name.Length -lt 17 }

foreach ($file in $files) {
    $sourceFilePath = $file.FullName
    $destinationFilePath = Join-Path $destinationPath $file.Name
    Move-Item $sourceFilePath $destinationFilePath
}
