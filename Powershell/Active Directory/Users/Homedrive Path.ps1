$OUpath = "OU=Staff,OU=Users,OU=HY,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"

 Get-AdUser -Filter * -SearchBase $OUPath -Properties * | Select UserPrincipalName,HomeDirectory | Sort-Object -Descending Name |  Export-CSV -Path C:\HY-home-directory1.csv -NoTypeInformation