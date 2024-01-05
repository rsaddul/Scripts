Import-Module ActiveDirectory


$Servers = Get-ADComputer -Property * -Filter {OperatingSystem -like '*Windows Server *'} | Select-Object Name,OperatingSystem | Sort-Object OperatingSystem -Descending
$Path = "c:\Server.txt"


$Servers | Out-File -FilePath $Path