$BLV = Get-BitLockerVolume -MountPoint "C:"
$KeyProt = $BLV.KeyProtector | Where-object{$_.KeyProtectorType -eq "RecoveryPassword"}
$KeyProt.KeyProtectorId
Remove-BitlockerKeyProtector -MountPoint "C:" -KeyProtectorId $KeyProt.KeyProtectorId
Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryPasswordProtector
$BLV = Get-BitLockerVolume -MountPoint "C:"
$KeyProt = $BLV.KeyProtector | Where-object{$_.KeyProtectorType -eq "RecoveryPassword"}
$KeyProt.KeyProtectorId
Backup-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $KeyProt.KeyProtectorId
Resume-BitLocker -MountPoint "C:"