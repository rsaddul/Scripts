############################
# Developed By Rhys Saddul #
############################

# This script will tell us, the count of folders inside the ccmcache older than X days which will help us to clean the content
# Change the number of days that you want to delete content older than.

 
$MinDays = 14
$UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
$Cache = $UIResourceMgr.GetCacheInfo()
($Cache.GetCacheElements() |
where-object {[datetime]$_.LastReferenceTime -lt (get-date).adddays(-$mindays)} |
Measure-object).Count