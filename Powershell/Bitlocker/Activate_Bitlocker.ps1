$BLV = Get-BitLockerVolume -MountPoint "C:"

$KeyProt = $BLV.KeyProtector | Where-object{$_.KeyProtectorType -eq "RecoveryPassword"}

$KeyProt.KeyProtectorId

Backup-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $KeyProt.KeyProtectorId