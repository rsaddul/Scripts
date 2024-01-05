' Script to start HCUC Info cmdlet without opening a PowerShell window

command = "powershell.exe -nologo -command C:\HCUC\Scripts\IT_Support\HCUC-Info.ps1"
 set shell = CreateObject("WScript.Shell")
 shell.Run command,0