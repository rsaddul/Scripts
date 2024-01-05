# This script should be used to fix  ADM or ADMX files that can no longer be found.
# If you were to start GP Editor on this GPO shown above, you would not see these settings anywhere in the Administrative Templates namespace, which is the problem.

# GPO Name
$GPO = "EDU - Global Staff User Policy V1.0"

# Remove the specific registry value from the GPO
Remove-GPRegistryValue -Name $GPO -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -ValueName "ListViewShadow"
Remove-GPRegistryValue -Name $GPO -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ValueName "Btn_Media"
Remove-GPRegistryValue -Name $GPO -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\" -ValueName "NoDrives"
Remove-GPRegistryValue -Name $GPO -Key "HKCU\Software\Policies\Microsoft\Windows\Backup\Client" -ValueName "DisableBackupUI"
Remove-GPRegistryValue -Name $GPO -Key "HKCU\Software\Policies\Microsoft\Windows\Backup\Client" -ValueName "DisableRestoreUI"
Remove-GPRegistryValue -Name $GPO -Key "HKCU\Software\Policies\Microsoft\Windows\Windows Collaboration" -ValueName "TurnOffWindowsCollaboration"
