function Get-AzVMBackupInformation {
[CmdletBinding(SupportsShouldProcess=$True,
ConfirmImpact='Medium',
HelpURI='http://vcloud-lab.com',
DefaultParameterSetName = 'AllVirtualMachines'
)]

#Prerequisites
#Install Azure PowerShell (Install-Module -Name Az -AllowClobber -Scope CurrentUser)
#Install Azure CLI (https://aka.ms/installazurecliwindows)
#Install ImportExcel (Install-Module -Name ImportExcel -RequiredVersion 5.4.0)

# You may need add the server to the Azure CLI
# az login --use-device-code

#Creating a JSON file to bypass authentication process
#Connect-AzAccount
#Disconnect-AzAccount -username "rsaddul@hcuc.ac.uk"
#Save-AzContext -Path "C:\Azure Backups\Automated_Scripts.json"

#JSON file used to prevent the MFA process in automated scripts
$profilePath = "C:\Azure Backups\Automated_Scripts.JSON"
$profile = Import-AzContext -Path $profilePath
#$SubscriptionID = $profile.Context.Subscription.SubscriptionId
#Set-AzContext -SubscriptionId $SubscriptionID


# Recording Script Start Date & Time
$Date = Get-Date -Format dd-MM-yyyy

# Disable the Suppress Azure PowerShell Breaking Change Warnings
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

Write-Host "VERBOSE: Script Execution Start Date & Time : $Date" -ForegroundColor Cyan

# Final Output Path.

$Output_Folder_Path = "\\uxcolfs04\library$\ITServices\Information\Logs\Azure Backups\"
$Output_Path_CSV = $Output_Folder_Path + "Azure_VM_Backup_Items" +" " + "$Date" + ".csv"
$Output_Path_XLSX = $Output_Folder_Path + "Azure_VM_Backup_Items" +" " + "$Date" + ".xlsx"

Write-Host "VERBOSE: CSV Output File Path : $Output_Path_CSV" -ForegroundColor Cyan
Write-Host "VERBOSE: XLSX Output File Path : $Output_Path_XLSX" -ForegroundColor Cyan

# Connect to Azure using Azure PowerShell.
#Connect-AzAccount

# Getting List of Subscriptions.
$Subscription_List = Get-AzSubscription | Select-Object -ExpandProperty id
(Get-AzSubscription).Name

#
foreach ($Subscription in $Subscription_List){
    
    $x++
    $Subscription_Name = Get-AzSubscription -SubscriptionId $Subscription | Select-Object -ExpandProperty Name
    
    
    $Current_Subscription_PS = Select-AzSubscription -Subscription $Subscription
    
    Write-Host "VERBOSE: Working on $Subscription_Name Subcription " -ForegroundColor Cyan

    # Getting Vault list from Recovery Services vault.

    $Vault_List = (Get-AzRecoveryServicesVault).Name

    (Get-AzRecoveryServicesVault).Name
    
    Foreach ($Vault in $Vault_List){
        
        # Getting Vault Resource Group Name.

        $Vault_ResourecGroup = (Get-AzRecoveryServicesVault -Name $Vault).ResourceGroupName
        
        Write-Host "VERBOSE: Working on Vault: $Vault" -ForegroundColor Cyan
        Write-Host "VERBOSE: Vault ResourceGroup Name: $Vault_ResourecGroup" -ForegroundColor Cyan
        
        # Setting Vault Context.
    
        Get-AzRecoveryServicesVault -Name $Vault | Set-AzRecoveryServicesVaultContext

        
                
        $obj = @()
        $results = @()
        
        $Backup_JOb_List = az backup job list -g "$Vault_ResourecGroup" -v "$Vault" | ConvertFrom-Json

        # Get only last day backup report. Use below commands and comment above $Backup_JOb_List.
        # $Time_Range = (Get-Date).AddDays(-1).ToString('dd-MM-yyyy')
        #$Backup_JOb_List = az backup job list -g "$Vault_ResourecGroup" -v "$Vault" --start-time "$Time_Range" | ConvertFrom-Json
        
        Foreach ($Backup_Job in $Backup_JOb_List){

            $Backup_Job_ID = $Backup_Job.name    
            $Backup_Job_Detail = az backup job show -n "$Backup_Job_ID" -g "$Vault_ResourecGroup" -v "$Vault" | ConvertFrom-Json
            $Backup_Job_Task = $Backup_Job_Detail.properties.extendedInfo.tasksList.taskId 

                $obj = New-Object -TypeName PSobject
                $obj | Add-Member -MemberType NoteProperty -Name Subscription -Value $Subscription_Name
                #$obj | Add-Member -MemberType NoteProperty -Name ResouceGroup -Value $Vault_ResourecGroup
                $obj | Add-Member -MemberType NoteProperty -Name Vault -Value $Vault
                #$obj | Add-Member -MemberType NoteProperty -Name JobID -Value $Backup_Job.name
                $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $Backup_Job.properties.entityFriendlyName
                #$obj | Add-Member -MemberType NoteProperty -Name JobType -Value $(if($Backup_Job.properties.jobtype -eq "MabJob") { 'File and Folder' } else{ 'Snapshot'})
                $obj | Add-Member -MemberType NoteProperty -Name Status -Value $Backup_Job.properties.status
                $obj | Add-Member -MemberType NoteProperty -Name Task -Value $("$Backup_Job_Task")
                $obj | Add-Member -MemberType NoteProperty -Name BackupSize -Value $Backup_Job_Detail.properties.extendedInfo.propertyBag.'Backup Size'
                $obj | Add-Member -MemberType NoteProperty -Name StartTime -Value $Backup_Job.properties.starttime.Split(".")[0]
                #$obj | Add-Member -MemberType NoteProperty -Name Duration -Value $Backup_Job.properties.duration.Split(".")[0]
                $obj | Add-Member -MemberType NoteProperty -Name ErrorDetails -Value $(if($Backup_Job.properties.errordetails.errorstring -ne $null){$Backup_Job.properties.errordetails.errorstring.Split(".")[1]}else{'No Error found'})
                $obj | Add-Member -MemberType NoteProperty -Name Recommendations -Value $(if($Backup_Job.properties.errordetails.recommendations -ne $null){$Backup_Job.properties.errordetails.Recommendations.Split(".")[0]}else{'No Recommendations'})
                
                $results +=$obj

        } $results | Export-csv "$Output_Path_CSV" -Append -NoTypeInformation -Verbose
    }
}



# Exporting report to Excel.

$Export_To_Excel = Import-csv -Path "$Output_Path_CSV" | Export-Excel "$Output_Path_XLSX" -IncludePivotTable -PivotRows Subscription -PivotColumns Status,Jobtype -PivotData Status -Verbose
}


Get-AzSubscription | ForEach-Object {
$_ | Set-AzContext
Get-AzVMBackupInformation
}