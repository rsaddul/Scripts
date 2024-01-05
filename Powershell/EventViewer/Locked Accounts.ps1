$Server = Read-Host -Prompt "Please specify the DC name you wish to connect to"

Invoke-Command -ScriptBlock {Get-EventLog -Newest 10 -LogName Security -InstanceId 4740 | Select-Object TimeGenerated , Message | FL} -ComputerName $Server | Out-File "C:\Locked_Accounts.txt" -Append -Encoding ascii