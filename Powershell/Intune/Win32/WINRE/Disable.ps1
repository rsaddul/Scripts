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
    Write-Host "Windows Recovery Environment is enabled."

    # Disable Windows Recovery Environment
    $disableResult = reagentc.exe /disable

    if ($disableResult -like "*Operation Successful*") {
        Write-Host "Windows Recovery Environment has been disabled."
    } else {
        Write-Host "Failed to disable Windows Recovery Environment."
    }
} else {
    Write-Host "Windows Recovery Environment is already disabled."
}

# Always create a 'wubredisabled.txt' file to indicate it was checked
New-Item -Path "C:\WINRE\wubredisabled.txt" -ItemType File -Force
