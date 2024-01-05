
$Array = @(
 "UX Security - Servers",
 "HH Security - Servers",
 "HAY Security - Servers",
 "HW Security - Servers"
 )


$Servers = @( Foreach ($S in $Array){
Get-ADGroupMember -Identity $S 
}
)


Foreach ($Server in $Servers.Name){
$Hide = Invoke-Command -ComputerName $Server -ScriptBlock {Get-LocalUser | Where-Object {$_.Enabled -eq $True}}
Write-Host "$Server has a local account called $Hide" -ForegroundColor Green
"$Server has a local account called $Hide" | Out-File "\\Uxcolfs04\library$\ITServices\Information\Logs\Servers\Server_Local_Accounts.log" -Append
}


