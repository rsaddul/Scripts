# Define variables
$serviceNames = @("ccmsetup", "CcmExec", "smstsmgr", "CmRcService")
$registryPaths = @(
    "HKLM:\SYSTEM\CurrentControlSet\Services\CCMSetup",
    "HKLM:\SYSTEM\CurrentControlSet\Services\CcmExec",
    "HKLM:\SYSTEM\CurrentControlSet\Services\smstsmgr",
    "HKLM:\SYSTEM\CurrentControlSet\Services\CmRcService",
    "HKLM:\SOFTWARE\Microsoft\CCM",
    "HKLM:\SOFTWARE\Microsoft\CCMSetup",
    "HKLM:\SOFTWARE\Microsoft\SMS",
    "HKLM:\SOFTWARE\Microsoft\DeviceManageabilityCSP"
)
$folders = @(
    "$env:WinDir\CCM",
    "$env:WinDir\ccmsetup",
    "$env:WinDir\ccmcache"
)

# Check if SCCM-related services are running
foreach ($serviceName in $serviceNames) {
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($service -ne $null) {
        Write-Output "SCCM-related service $serviceName is running"
        $sccmDetected = $true
    }
}

# Check if SCCM-related registry keys exist
foreach ($registryPath in $registryPaths) {
    if (Test-Path $registryPath) {
        Write-Output "SCCM-related registry key $registryPath detected"
    }
}

# Check if SCCM Agent is installed
$CCMpath = 'C:\Windows\ccmsetup\ccmsetup.exe'
if (Test-Path $CCMpath) {
    exit 1
}
else {
    exit 0
}
