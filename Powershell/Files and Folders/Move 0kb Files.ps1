$filepath = "C:\TEST\"
$filedestination = "C:\Other\"

$FileLength = Get-ChildItem -path $filePath | Where-Object {$_.Length -eq 0}

$FileLength | ForEach-Object {
    $path = $_.fullname
    $destination = $filedestination + $_.name
    Move-Item $path $destination
}

