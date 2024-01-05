#Define the variables needed (SIMS VBM)-

$Path = "\\cs-backup\e$\Backup\SIMS2\*.vbm" #folder where files are
$NumberOfFiles = "1" #Number of files to move
$Destination = '\\10.210.192.162\backup\SIMS2' #Destination of files being moved
$Daysback = "-7" #Minimum age of files to delete
$CurrentDate = Get-Date #Todays date
$DatetoDelete = $CurrentDate.AddDays($Daysback) #calculate the date before which to delete files
$logProgress = "\\10.210.192.161\itsupport\VM Backup Logs\SIMS2\SIMS_VBM.log" #name of log file

#Get a list of the last 2 files to be created, change -first to -last if you want the oldest
$FilesToMove = Get-ChildItem -Path $Path -File | Sort-Object -Property CreationTime -Descending | Select-Object -First $NumberOfFiles | Select-Object -Property FullName


#Copy the files to new destination
Foreach ($file in $FilesToMove) {Copy-Item -Path $file.FullName -Destination $destination -Force -ErrorAction SilentlyContinue #copy each file

if($? -eq $false){Write-Output -InputObject "$($file.FullName) did not copy ok to $destination" | out-file -FilePath $logProgress -appends} #if it fails write error

else

{write-output -InputObject "$($file.FullName) copied OK to $destination" | out-file -FilePath $logProgress -append } #if ok, write ok
}

#Delete the files older than specified
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item 

#Connection Details SMTP
$smtpServer = “172.30.178.12”
$msg = new-object Net.Mail.MailMessage

#Change port number for SSL to 587
$smtp = New-Object Net.Mail.SmtpClient($SmtpServer, 25) 

#Uncomment Next line for SSL  
#$smtp.EnableSsl = $true

$smtp.Credentials = New-Object System.Net.NetworkCredential( $username, $password )

#From Address
$msg.From = "papercut@christs.richmond.sch.uk"
#To Address, Copy the below line for multiple recipients
$msg.To.Add(“itsupport@christs.richmond.sch.uk”)

#Message Body
$msg.Body=”Please See Attached SIMS VBM Logs”

#Message Subject
$msg.Subject = “Email with SIMS VBM Logs”

#your file location
$files=Get-ChildItem “\\10.210.192.161\itsupport\VM Backup Logs\SIMS2\SIMS_VBM.log”

Foreach($file in $files)
{
Write-Host “Attaching File :- ” $file
$attachment = New-Object System.Net.Mail.Attachment –ArgumentList "\\10.210.192.161\itsupport\VM Backup Logs\SIMS2\SIMS_VBM.log"
$msg.Attachments.Add($attachment)

}
$smtp.Send($msg)
$attachment.Dispose();
$msg.Dispose();