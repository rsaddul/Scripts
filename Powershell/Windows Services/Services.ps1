#Start service if stopped

$ServiceName = "PS Online"
$Service = Get-Service -Name $ServiceName

If ($Service.Status -eq "Stopped")
{
Start-Service -Name $ServiceName
Write-Host "The $ServiceName has been Started" -ForegroundColor Black -BackgroundColor Cyan
}
Else
{
Write-Host "$ServiceName is already Started" -ForegroundColor Black -BackgroundColor Red
}

#Stop service if running

$ServiceName = "Spooler"
$Service = Get-Service -Name $ServiceName

If ($Service.Status -eq "Running")
{
Stop-Service -Name $ServiceName
Write-Host "The $ServiceName service has been stopped" -ForegroundColor Black -BackgroundColor Cyan
}
Else
{
Write-Host "$ServiceName has already Stopped" -ForegroundColor Black -BackgroundColor Red
}
