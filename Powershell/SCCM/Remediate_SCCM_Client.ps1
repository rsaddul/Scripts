##########################################################
# $ccmpath is path to SCCM Agent's own uninstall routine #
##########################################################
$CCMpath = 'C:\Windows\ccmsetup\ccmsetup.exe'

###################################################################
# If path exists we will remove it, or else we will silently fail #
###################################################################
if (Test-Path $CCMpath) {

    Start-Process -FilePath $CCMpath -Args "/uninstall" -Wait -NoNewWindow

    ############################
    # Wait for process to exit #
    ############################
        $CCMProcess = Get-Process ccmsetup -ErrorAction SilentlyContinue

        try{
            $CCMProcess.WaitForExit()
            }catch{
 

            }
}

##############################
# Stop SCCM related services #
##############################
Stop-Service -Name ccmsetup -Force -ErrorAction SilentlyContinue
Stop-Service -Name CcmExec -Force -ErrorAction SilentlyContinue
Stop-Service -Name smstsmgr -Force -ErrorAction SilentlyContinue
Stop-Service -Name CmRcService -Force -ErrorAction SilentlyContinue

#############################
# Wait for services to exit #
#############################
$CCMProcess = Get-Process ccmexec -ErrorAction SilentlyContinue
try{

    $CCMProcess.WaitForExit()

}catch{


}

#########################
# Remove WMI Namespaces #
#########################
Get-WmiObject -Query "SELECT * FROM __Namespace WHERE Name='ccm'" -Namespace root | Remove-WmiObject
Get-WmiObject -Query "SELECT * FROM __Namespace WHERE Name='sms'" -Namespace root\cimv2 | Remove-WmiObject

##############################################
# Set $CurrentPath to services registry keys #
##############################################
$CurrentPath = "HKLM:\SYSTEM\CurrentControlSet\Services"

#################################
# Remove Services from Registry #
#################################
Remove-Item -Path $CurrentPath\CCMSetup -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\CcmExec -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\smstsmgr -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\CmRcService -Force -Recurse -ErrorAction SilentlyContinue

##################################################
# Update $CurrentPath to HKLM/Software/Microsoft #
##################################################
$CurrentPath = "HKLM:\SOFTWARE\Microsoft"

####################################
# Remove SCCM Client from Registry #
####################################
Remove-Item -Path $CurrentPath\CCM -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\CCMSetup -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\SMS -Force -Recurse -ErrorAction SilentlyContinue

#######################
# Reset MDM Authority #########################################################################################################
# CurrentPath should still be correct, we are removing this key: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\DeviceManageabilityCSP #
###############################################################################################################################
Remove-Item -Path $CurrentPath\DeviceManageabilityCSP -Force -Recurse -ErrorAction SilentlyContinue

############################
# Remove Folders and Files ##########
# Tidy up garbage in Windows folder #
#####################################
$CurrentPath = $env:WinDir
Remove-Item -Path $CurrentPath\CCM -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\ccmsetup -Force -Recurse -ErrorAction SilentlyContinue
