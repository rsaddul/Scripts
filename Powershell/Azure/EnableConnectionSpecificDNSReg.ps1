$Adapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=TRUE"
$Adapters | ForEach-Object {
    $_.SetDynamicDNSRegistration($TRUE, $TRUE)
}