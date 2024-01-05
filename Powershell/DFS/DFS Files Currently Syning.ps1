#The Get-DfsrState cmdlet gets the overall Distributed File System (DFS) Replication state for a computer in regard to its replication group partners. 
#The cmdlet returns a count of files waiting to sync

$Items = Get-DFSrState | Where-Object {$_.UpdateStatus -ne "Waiting"}

$Items.count