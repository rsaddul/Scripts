#Gets a list of the applications that are installed on the machine.
Get-WmiObject -Class Win32_Product |
Sort-Object -Property @{ Expression = 'Name'; Descending = $false }, @{ Expression = 'IdentifyingNumber'; Ascending = $false } |
Format-Table -Property Name,IdentifyingNumber


#Maps Variable to list of installed applications and sorts it in order
$List = @{ Expression = 'Name'; Descending = $false }, @{ Expression = 'IdentifyingNumber'; Ascending = $false }
Get-WmiObject -Class Win32_Product | Sort-Object -Property $List | Format-Table -Property Name,IdentifyingNumber

=================================================================================================================================================

#Maps Variable to the application 
$MyApp = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Teams Machine-Wide Installer"}

#Sometimes Powershell seems to know nothing of this application if so you will need to use the get-package commands

#Uninstalls the application from the mapped varible above
$MyApp.Uninstall()

=================================================================================================================================================

#Maps Variable to the application 
$MyApp = Get-Package -Provider Programs -IncludeWindowsInstaller -Name "Teams Machine-Wide Installer"

#Uninstalls the application
Uninstall-Package -Name "Teams Machine-Wide Installer"

=================================================================================================================================================