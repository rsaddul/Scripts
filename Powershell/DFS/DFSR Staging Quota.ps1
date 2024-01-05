#This script will help you identify the correct size required for stage quota for DFSR

#This command will return the file names and the size of the files in bytes. Useful if you want to know what 32 files are the largest in the Replicated Folder so you can “visit” their owners.
Get-ChildItem 'E:\Shared\CHE' -recurse | Sort-Object length -descending | select-object -first 32 | measure-object -property length –sum

#This will divide the total by 1073741824 to get the minimum staging area quota 
enter sum value here from above command / 1073741824
