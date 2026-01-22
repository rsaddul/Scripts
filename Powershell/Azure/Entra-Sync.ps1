###########################
# Developed by Rhys Saddul #
###########################

function Start-ADSyncCycle {
    param (
        [string]$Server,
        [string]$Type
    )

    $Status = Invoke-Command -ScriptBlock { Get-ADSyncConnectorRunStatus } -ComputerName $Server

    if ($Status.RunState -like "*Busy*") {
        Write-Host "Synchronization for $Server is currently running" -ForegroundColor Red
    }
    else {
        if ($Type -eq "Delta") {
            Invoke-Command -ScriptBlock { Start-ADSyncSyncCycle -PolicyType Delta } -ComputerName $Server
            Write-Host "Starting Delta Sync on $Server" -ForegroundColor Green
        }
        elseif ($Type -eq "Initial") {
            Invoke-Command -ScriptBlock { Start-ADSyncSyncCycle -PolicyType Initial } -ComputerName $Server
            Write-Host "Starting Initial Sync on $Server" -ForegroundColor Green
        }
        else {
            Write-Host "Invalid synchronization type specified: $Type" -ForegroundColor Red
        }
    }
}

$Server = Read-Host "AAD Server Name"
$Type = Read-Host "Please type Delta or Initial"

Write-Host "We shall run a sync for $Server" -ForegroundColor Green

Start-ADSyncCycle -Server $Server -Type $Type
