###########################
# Developed by Rhys Saddul #
###########################


#Check When AAD Last Synced
If(-not (Get-MsolDomain -ErrorAction SilentlyContinue)){
Connect-MsolService
Get-MSOLCompanyInformation | Select-Object LastDirSyncTime,LastPasswordSyncTime | Format-List
}
Else {
Get-MSOLCompanyInformation | Select-Object LastDirSyncTime,LastPasswordSyncTime | Format-List
}