' Script to start HCUC Info cmdlet without opening a PowerShell window

command = "powershell.exe -nologo -command C:\HCUC\SharePoint\UX\AD-UX-IT-SPSync.ps1"
 set shell = CreateObject("WScript.Shell")
 shell.Run command,0