Get-ChildItem -Path "\\GLF-PSFAPP\PSFDocuments$\DTT Interfaces\V6 Interfaces\Automatic Document Attachment\Prep" |
Where-Object {
$_.LastWriteTime -lt (Get-Date).AddMinutes(-5)
} |
Move-Item -Destination "\\GLF-PSFAPP\PSFDocuments$\DTT Interfaces\V6 Interfaces\Automatic Document Attachment\To Process"