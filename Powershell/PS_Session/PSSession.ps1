#Will log all session in a text file
Start-Transcript

#Shows active PSSsessions
Get-PSSession

#Enters PSSession with ID 8
Enter-PSSession 8

#Exits PSSession but keeps it opened
exit

#Disconnects PSSession with ID 8 (no longer uses network resources)
Disconnect-PSSession 8

#Connects to PSSession with ID 8
Connect-PSSession 8

#Removes the PSSession with ID 8 (when you are finished)
Remove-PSSession 8

#Invoke Command allows you to run a script on multipls servers (the below command will find the IP details of two servers)
Invoke-Command -ComputerName glf-sims01, glfsims02 -ScriptBlock {ipconfig /all}