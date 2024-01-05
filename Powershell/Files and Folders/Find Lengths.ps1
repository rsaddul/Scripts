$Date = Get-Date -Format "MM/dd/yyyy - "
$Log = "C:\Log.txt"
$Path = "C:\Users\rsaddul\OneDrive - HCUC\Documents\T.csv"

$CSV = Import-Csv $Path

ForEach($Record in $CSV) {

$From = $Record.From
$To = $Record.To
$ID = $Record.Users
Dir $Record.From -file -recurse -ErrorAction SilentlyContinue | select Fullname,@{Name=”NameLength”;Expression={$_.fullname.length}} | Export-Csv -Path "c:\long.csv"

}
