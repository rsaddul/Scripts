#Install AzureRm module
#Install-Module -Name AzureRM -AllowClobber

#Check to see that AzureRm is installed
#Get-InstalledModule

#Install Az PowerShell module
#Install-Module -Name PowerShellGet -Force
#Install-Module -Name Az -AllowClobber -Scope CurrentUser (This avoids the warning you encounter from running the script in the documentation: "Warning: Az module not installed. Having both the AzureRM and Az Modules installed at the same time is not supported.")

#Uninstall AzureRm module
#Set-ExecutionPolicy RemoteSigned (This avoids the error: "The 'Uninstall-AzureRm' command was found in the module 'Az.Accounts', but the module could not be loaded.")
#Uninstall-AzureRm

#Confirm that all AzureRm modules have been uninstalled
#Get-InstalledModule

#Creating a JSON file to bypass authentication process
#Connect-AzAccount
#Disconnect-AzAccount -username "rsaddul@hcuc.ac.uk"
#Save-AzContext -Path "C:\Azure Backups\Automated_Scripts.json"


[CmdletBinding(SupportsShouldProcess=$True,
    ConfirmImpact='Medium',
    DefaultParameterSetName = 'AllVirtualMachines'
)]

Param
( 
    [parameter(Position=0, ParameterSetName = 'AllVMs' )]
    [Switch]$AllVirtualMachines,
    [parameter(Position=0, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, ParameterSetName = 'VM' )]
    [alias('Name')]
    [String[]]$VirtualMachineList
) #Param
Begin 
{

#JSON file used to prevent the MFA process in automated scripts
$profilePath = "C:\Azure Backups\Rhys_Automated_Scripts.JSON"
$profile = Import-AzContext -Path $profilePath
$SubscriptionID = $profile.Context.Subscription.SubscriptionId
Set-AzContext -SubscriptionId $SubscriptionID


    #Collecing Azure virtual machines Information
    Write-Host "Collecing Azure virtual machine Information" -BackgroundColor DarkGreen
    if (($PSBoundParameters.ContainsKey('AllVirtualMachines')) -or ($PSBoundParameters.Count -eq 0))
    {
        $vms = Get-AzVM
    } #if ($PSBoundParameters.ContainsKey('AllVirtualMachines'))
    elseif ($PSBoundParameters.ContainsKey('VirtualMachineList'))
    {
        $vms = @()
        foreach ($vmname in $VirtualMachineList)
        {
            $vms += Get-AzVM -Name $vmname
            
        } #foreach ($vmname in $VirtualMachineList)
    } #elseif ($PSBoundParameters.ContainsKey('VirtualMachineList'))

    #Collecing All Azure backup recovery vaults Information
    Write-Host "Collecting all Backup Recovery Vault information" -BackgroundColor DarkGreen
    $backupVaults = Get-AzRecoveryServicesVault
} #Begin 
Process
{
    $vmBackupReport = [System.Collections.ArrayList]::new()
    foreach ($vm in $vms) 
    {
        $recoveryVaultInfo = Get-AzRecoveryServicesBackupStatus -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Type 'AzureVM'
        if ($recoveryVaultInfo.BackedUp -eq $true)
        {
            Write-Host "$($vm.Name) - BackedUp : Yes"
            #Backup Recovery Vault Information
            $vmBackupVault = $backupVaults | Where-Object {$_.ID -eq $recoveryVaultInfo.VaultId}

            #Backup recovery Vault policy Information
            $container = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVM -VaultId $vmBackupVault.ID -FriendlyName $vm.Name #-Status "Registered" 
            $backupItem = Get-AzRecoveryServicesBackupItem -Container $container -WorkloadType AzureVM -VaultId $vmBackupVault.ID
        } #if ($recoveryVaultInfo.BackedUp -eq $true)
        else 
        {
            Write-Host "$($vm.Name) - BackedUp : No" -BackgroundColor DarkRed
            $vmBackupVault = $null
            $container =  $null
            $backupItem =  $null
        } #else if ($recoveryVaultInfo.BackedUp -eq $true)
        
        [void]$vmBackupReport.Add([PSCustomObject]@{
            VM_Name = $vm.Name
            #VM_Location = $vm.Location
            #VM_ResourceGroupName = $vm.ResourceGroupName
            VM_BackedUp = $recoveryVaultInfo.BackedUp
            #VM_RecoveryVaultName =  $vmBackupVault.Name
            #VM_RecoveryVaultPolicy = $backupItem.ProtectionPolicyName
            VM_BackupHealthStatus = $backupItem.HealthStatus
            VM_BackupProtectionStatus = $backupItem.ProtectionStatus
            VM_LastBackupStatus = $backupItem.LastBackupStatus
            VM_LastBackupTime = $backupItem.LastBackupTime
            #VM_BackupDeleteState = $backupItem.DeleteState
            VM_BackupLatestRecoveryPoint = $backupItem.LatestRecoveryPoint
            #VM_Id = $vm.Id
            #RecoveryVault_ResourceGroupName = $vmBackupVault.ResourceGroupName
            #RecoveryVault_Location = $vmBackupVault.Location
            #RecoveryVault_SubscriptionId = $vmBackupVault.ID
        }) #[void]$vmBackupReport.Add([PSCustomObject]@{
    } #foreach ($vm in $vms) 
} #Process
end
{   
    $Date = Get-Date -Format dd-MM-yyyy
    $vmBackupReport | Export-Csv "\\uxcolfs04\library$\ITServices\Information\Logs\Azure Backups\VmBackupReport $Date.csv"
} #end


