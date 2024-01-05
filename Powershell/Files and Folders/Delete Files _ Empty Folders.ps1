#Delete files that have not been accessed in 180 days variables

$Date = Get-Date -Format dd-MM-yyyy
$Days = 1
$Limit = (Get-Date).AddDays($Days * -1)
$Files = Get-ChildItem "C:\Windows\Temp" -Recurse


#Delete Empty Files and Folders Variable

$Path = Get-ChildItem -Recurse "C:\Users\Rhys's Desktop\Desktop\Work"


#Delete Empty Files and Folders

$Path | ForEach {
    $FullName = $_.FullName
       if($_.Length -eq 0){
       $Output =  "Removing Empty Files $($_.fullname)" | Out-File "C:\log\Deleted Empty Files $Date.txt" -Append -Encoding ascii
          Write-Host "Removing Empty File $($FullName)" -ForegroundColor Black -BackgroundColor Cyan
          $_.FullName | Remove-Item -Force -WhatIf
       }
       if( $_.psiscontainer -eq $true){
          if((Get-ChildItem $FullName) -eq $null){
          $Output =  "Removing Empty Folders $($_.fullname)" | Out-File "C:\log\Deleted Empty Folders $Date.txt" -Append -Encoding ascii
          Write-Host "Removing Empty folder $($FullName)" -ForegroundColor Black -BackgroundColor Cyan
             $_.FullName | Remove-Item -Force -WhatIf
          }
    }
}

#Delete files that have not been accessed in 180 days

$Files | ForEach {
   if($_.LastAccessTime -lt $Limit){
   $Output =  "Deleting files that have not been accessed $Days Days $($_.fullname)" | Out-File "C:\log\Deleted Old Files $Date.txt" -Append -Encoding ascii
      Write-Host "Deleting files that have not been accessed $Days Days $($_.fullname)" -ForegroundColor Black -BackgroundColor Red
      $_.FullName | Remove-Item -Recurse -Force -WhatIf
   }
   }