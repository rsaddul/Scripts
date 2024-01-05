$MachineName = Read-Host -Prompt "Please enter the machine name that will be restarted in 6 hours"


(Invoke-Command -ComputerName $MachineName -ScriptBlock {shutdown /t 15300 /r /c "Computer will be rebooted in 6 hours"})