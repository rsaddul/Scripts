#Import-Module ActiveDirectory

$Group = "HCUC - Decomissioned Servers"

$List = Get-Content "C:\Users\rsaddul\OneDrive - HCUC\Documents\Server.csv"

Foreach ($Computer in $List) {
Add-ADGroupMember -Identity $Group -Members (Get-ADComputer $computer)
}


