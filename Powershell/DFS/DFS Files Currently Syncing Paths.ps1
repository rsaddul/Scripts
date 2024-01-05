#The Get-DfsrState cmdlet gets the overall Distributed File System (DFS) Replication state for a computer in regard to its replication group partners. 
#The cmdlet returns both inbound and outbound file replication information, such as files currently replicating and files immediately queued to replicate next.

Get-DfsrState -ComputerName "GLF-SPR-FILE01" | Select-Object FileName,UpdateState,Path,Inbound,Source* | Export-Csv -Path ".\count.csv" -NoTypeInformation