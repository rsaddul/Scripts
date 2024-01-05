$sid = "S-1-5-21-2865035389-1569799765-2681417579-2200562" # Replace with the SID number you want to check
$groups = Get-ADGroup -Filter {SID -eq $sid} -Properties Members

if ($groups) {
    $members = $groups.Members | ForEach-Object {
        Get-ADObject $_ | Select-Object -ExpandProperty Name
    }
    Write-Output "The following user(s) or group(s) belong to the group with SID $sid: ${members -join ', '}"
} else {
    Write-Output "No group was found with SID $sid."
}
