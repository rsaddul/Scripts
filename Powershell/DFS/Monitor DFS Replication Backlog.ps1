﻿#Gets DFSR backlog counts for all replication groups or one(s) you specify
#The Get-DfrsBacklog cmdlet retrieves pending updates between two computers that participate in Distributed File System (DFS) Replication.
#Updates can be new, modified, or deleted files and folders.

 
Param (
    [String[]]$ReplicationGroupList = ("")
)
 
$RGroups = Get-WmiObject  -Namespace "root\MicrosoftDFS" -Query "SELECT * FROM DfsrReplicationGroupConfig"
#If  replication groups specified, use only those.
if($ReplicationGroupList)
{
    $SelectedRGroups = @()
    foreach($ReplicationGroup IN $ReplicationGroupList)
    {
        $SelectedRGroups += $rgroups | Where-Object {$_.ReplicationGroupName -eq $ReplicationGroup}
    }
    if($SelectedRGroups.count -eq 0)
    {
        Write-Error "None of the group names specified were found, exiting"
        exit
    }
    else
    {
        $RGroups = $SelectedRGroups
    }
}
        
$ComputerName=$env:ComputerName
$Succ=0
$Warn=0
$Err=0
$dt = Get-Date -UFormat "%A %m-%d-%Y %R"
Start-Transcript -path "c:\scripts\dfsr1-$dt.txt"
foreach ($Group in $RGroups)
{
    $RGFoldersWMIQ = "SELECT * FROM DfsrReplicatedFolderConfig WHERE ReplicationGroupGUID='" + $Group.ReplicationGroupGUID + "'"
    $RGFolders = Get-WmiObject -Namespace "root\MicrosoftDFS" -Query  $RGFoldersWMIQ
    $RGConnectionsWMIQ = "SELECT * FROM DfsrConnectionConfig WHERE ReplicationGroupGUID='"+ $Group.ReplicationGroupGUID + "'"
    $RGConnections = Get-WmiObject -Namespace "root\MicrosoftDFS" -Query  $RGConnectionsWMIQ
    foreach ($Connection in $RGConnections)
    {
        $ConnectionName = $Connection.PartnerName#.Trim()
        if ($Connection.Enabled -eq $True)
        {
            #if (((New-Object System.Net.NetworkInformation.ping).send("$ConnectionName")).Status -eq "Success")
            #{
                foreach ($Folder in $RGFolders)
                {
                    $RGName = $Group.ReplicationGroupName
                    $RFName = $Folder.ReplicatedFolderName
 
                    if ($Connection.Inbound -eq $True)
                    {
                        $SendingMember = $ConnectionName
                        $ReceivingMember = $ComputerName
                        $Direction="inbound"
                    }
                    else
                    {
                        $SendingMember = $ComputerName
                        $ReceivingMember = $ConnectionName
                        $Direction="outbound"
                    }
 
                    $BLCommand = "dfsrdiag Backlog /RGName:'" + $RGName + "' /RFName:'" + $RFName + "' /SendingMember:" + $SendingMember + " /ReceivingMember:" + $ReceivingMember
                    $Backlog = Invoke-Expression -Command $BLCommand
 
                    $BackLogFilecount = 0
                    foreach ($item in $Backlog)
                    {
                        if ($item -ilike "*Backlog File count*")
                        {
                            $BacklogFileCount = [int]$Item.Split(":")[1].Trim()
                        }
                    }
 
                    if ($BacklogFileCount -eq 0)
                    {
                        $Color="white"
                        $Succ=$Succ+1
                    }
                    elseif ($BacklogFilecount -lt 10)
                    {
                        $Color="yellow"
                        $Warn=$Warn+1
                    }
                    else
                    {
                        $Color="red"
                        $Err=$Err+1
                    }
                    Write-Output "$BacklogFileCount files in backlog $SendingMember->$ReceivingMember for $RGName"
                    
                } # Closing iterate through all folders
            #} # Closing  If replies to ping
        } # Closing  If Connection enabled
    } # Closing iteration through all connections
} # Closing iteration through all groups
Write-Output "$Succ successful, $Warn warnings and $Err errors from $($Succ+$Warn+$Err) replications."
Stop-Transcript
 
#$file = "c:\scripts\dfsr1.txt"
 
#get-content $file |
   # select -Skip 18 |
   # set-content "$file-temp"
#move "$file-temp" $file -Force
 
#$emailrecipients = "email@address.com";
#$emailbody = Get-Content -Path c:\scripts\dfsr1.txt -Raw
 
#Send-MailMessage -to $emailrecipients -smtpserver 192.168.2.100 -from "DFSR System <DFSR@ADDRESS.COM>" -subject "DFSR Report for $(get-date -format MMM/dd/yyyy) from $env:COMPUTERNAME" -body $emailbody;
 
#Remove-Item c:\scripts\dfsr1.txt