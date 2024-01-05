# Developed by Rhys Saddul

# Check if the 'wubredisabled.txt' file exists and delete it if found
if (Test-Path -Path "C:\WINRE\wubredisabled.txt") {
    Remove-Item -Path "C:\WINRE\wubredisabled.txt" -Force
}

# Check if the 'wubreenabled.txt' file exists and delete it if found
if (Test-Path -Path "C:\WINRE\wubreenabled.txt") {
    Remove-Item -Path "C:\WINRE\wubreenabled.txt" -Force
}

# Check if Windows Recovery Environment is enabled
$reagentcOutput = reagentc.exe /info

if ($reagentcOutput -match "Windows RE status:\s+Enabled") {
    Write-Host "Windows Recovery Environment is already enabled."
}

# Enable Windows Recovery Environment
$enableResult = reagentc.exe /enable

if ($enableResult -like "*Operation Successful*") {
    Write-Host "Windows Recovery Environment has been enabled."
}

# Always create a 'wubreenabled.txt' file to indicate it was checked
New-Item -Path "C:\WINRE\wubreenabled.txt" -ItemType File -Force
