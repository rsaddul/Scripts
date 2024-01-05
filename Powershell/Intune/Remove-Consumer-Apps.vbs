' Script to start HCUC Info cmdlet without opening a PowerShell window

command = "powershell.exe -nologo -command C:\HCUC\OSD\Remove-Consumer-Apps.ps1"
 set shell = CreateObject("WScript.Shell")
 shell.Run command,0