$groupName = "HCUC MIS Admin Security - All Staff" # Replace with the name of the group you want to check
$group = Get-ADGroup -Identity $groupName
$group.SID.Value