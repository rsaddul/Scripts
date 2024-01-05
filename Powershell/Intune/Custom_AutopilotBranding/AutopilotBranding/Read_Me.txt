https://github.com/mtniehaus/AutopilotBranding/tree/master

Install Command:
powershell.exe -noprofile -executionpolicy bypass -file .\AutopilotBranding.ps1

Uninstall Commmand:
cmd.exe /c del %ProgramData%\Microsoft\AutopilotBranding\AutopilotBranding.ps1.tag


The detection rule should look for the existence of this file:
Path: %ProgramData%\Microsoft\AutopilotBranding File or filder: AutopilotBranding.ps1.tag

