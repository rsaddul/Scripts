New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" -Name "BlockAADWorkplaceJoin" -Value 1 -PropertyType "DWord" -Force | Out-Null
