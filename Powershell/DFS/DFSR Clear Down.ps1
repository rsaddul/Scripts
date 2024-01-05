#Make sure to change/remove the drive letters before running

Start-DedupJob I: -Type GarbageCollection -Full
Start-DedupJob I: -Type Scrubbing -Full
Start-DedupJob K: -Type GarbageCollection -Full
Start-DedupJob K: -Type Scrubbing -Full
Start-DedupJob E: -Type GarbageCollection -Full
Start-DedupJob E: -Type Scrubbing -Full
Start-DedupJob G: -Type GarbageCollection -Full
Start-DedupJob G: -Type Scrubbing -Full
Start-DedupJob H: -Type GarbageCollection -Full
Start-DedupJob H: -Type Scrubbing -Full
Start-DedupJob F: -Type GarbageCollection -Full
Start-DedupJob F: -Type Scrubbing -Full
Get-DedupJob