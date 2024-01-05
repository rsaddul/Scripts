#Create Application Shorcuts Folder
New-Item "C:\Users\$Env:Username\Desktop\ApplicationShortcuts" -itemType Directory

#This Copies All Files and Fodlers from Path to Desitnation
Copy-Item "\\resource\netlogon\HCLS\shortcuts\Desktop\ApplicationShortcuts\*" -Destination "C:\Users\rsaddul\Desktop\ApplicationShortcuts" -Recurse 