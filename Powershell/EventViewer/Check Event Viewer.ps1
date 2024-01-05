$eventLog = "Application"
$source = "PS Online"
$instance = 0
$entryType = "Error"
$time = (Get-Date).AddMinutes(-5)
$eventLogs = Get-EventLog -LogName $eventLog -Source $source -InstanceId $instance -EntryType $entryType -After $time

$nicetime = Get-Date -Format "HH-mm-ss"
$logPath = "C:\Task Scheduler Scripts\Logs\log $nicetime.txt"

Start-Transcript -Path $logPath

$eventLogs | ForEach-Object {
    $message = $_.Message
    
    if ($message -like "*Object reference not set to an instance of an object*") {
        Write-Host "Found a log" -ForegroundColor Cyan
        Write-Host "Stopping PS Online" -ForegroundColor Green
        
        Stop-Service -Name "PS Online"
        Start-Sleep -Seconds 5
        
        Write-Host "Starting PS Online" -ForegroundColor Red
        Start-Service -Name "PS Online"
        
        $test = $true
        
        while ($test) {
            if ((Get-Service "PS Online").Status -ne "Running") {
                Write-Host "Starting PS Online in While" -ForegroundColor Yellow
                
                Start-Service "PS Online"
                Start-Sleep -Seconds 2
            }
            else {
                $test = $false
                Write-Host "Done" -ForegroundColor DarkCyan
                Start-Sleep -Seconds 2
                break
            }
        }
    }
}

Stop-Transcript
