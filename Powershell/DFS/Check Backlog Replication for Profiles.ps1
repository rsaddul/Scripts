#The Get-DfrsBacklog cmdlet retrieves pending updates between two computers that participate in Distributed File System (DFS) Replication.
#Updates can be new, modified, or deleted files and folders.

$forever = 1

do
{
#Get the current date and time and reformat it
$CurrentDatetime = Get-Date -Format "dddd MM/dd/yyyy HH:mm"
$QueueLength1 = (Get-DfsrBacklog -Groupname "ad.glfschools.org\Shared$\SPR" -FolderName "SPR"  -SourceComputerName glf-file04 -DestinationComputerName glf-spr-file01 -verbose 4>&1).Message.Split(':')[2]
write-host $CurrentDatetime "Current Queue length equals: $QueueLength1"
start-sleep 10
}
while ($forever -gt 0)