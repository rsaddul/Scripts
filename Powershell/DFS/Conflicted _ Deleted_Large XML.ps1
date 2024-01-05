#The below command will automatically delete/create a new conflict and deleted xml file and should automatically clear down the conflicted and deleted folder.

#   Open CMD as Administrator and run the below command
#   WMIC.EXE /namespace:\\root\microsoftdfs path dfsrreplicatedfolderconfig get replicatedfolderguid,replicatedfoldername


#Run the below command to find the DFS GUID (identifier) if CMD is not clear

$GroupName = Read-Host "Please enter Replcation Group Name"
Get-DfsReplicatedFolder  -GroupName $GroupName | Select-Object Identifier


#  Use the GUID (identifier) you found in the below command in CMD

#  WMIC.EXE /namespace:\\root\microsoftdfs path dfsrreplicatedfolderinfo where "replicatedfolderguid='72a3c405-05ba-4f7f-8f00-8bc0e4723e91'" call cleanupconflictdirectory



