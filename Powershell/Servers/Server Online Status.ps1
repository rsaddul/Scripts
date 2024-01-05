$groups = @("HH Security - Servers", "HW Security - Servers", "UX Security - Servers", "HY Security - Servers", "Azure Security - Servers")  # List of security groups to check

function Check-ServerStatus {
    Param($computer)

    $status = "Online"
    if (!(Test-Connection -ComputerName $computer -Count 1 -Quiet)) {
        $status = "Offline"
        [console]::Beep(1000, 500)  # Play beep sound for 500ms
    }
    New-Object -TypeName PSObject -Property @{
        ComputerName = $computer
        Status = $status
    }
}

while ($true) {  # Run the check every 2 minutes
    $offline = @()

    foreach ($group in $groups) {
        $members = Get-ADGroupMember $group -Recursive | Where-Object { $_.objectClass -eq "computer" } | Select-Object -ExpandProperty Name
        $status = $members | ForEach-Object { Check-ServerStatus $_ }
        $offline += $status | Where-Object { $_.Status -eq "Offline" } | Select-Object -ExpandProperty ComputerName
    }

    Write-Host "Offline:`t$($offline.Count)" -ForegroundColor Red

    if ($offline.Count -gt 0) {
        Clear-Host
        Write-Host "$(Get-Date -Format 'HH:mm') - The following servers are offline:" -ForegroundColor Red
        $offline | ForEach-Object {
            Write-Host $_ -ForegroundColor Red
        }
    } else {
        Write-Host "$(Get-Date -Format 'HH:mm') - All servers are online." -ForegroundColor Green
    }
    
    Start-Sleep -Seconds 30  # Wait for 5 minutes before running the check again
}
