############################
# Developed By Rhys Saddul #
############################

# This script will clean the content (folders) older than 14 days
# Change the number of days that you want to delete content older than.

$MinDays = 14
$UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
$Cache = $UIResourceMgr.GetCacheInfo()
$Cache.GetCacheElements() |
where-object {[datetime]$_.LastReferenceTime -lt (get-date).adddays(-$mindays)} |
foreach {
$Cache.DeleteCacheElement($_.CacheElementID)
}