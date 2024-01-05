<#
 
.SYNOPSIS
    Checks for the current version of common software and sends an email notification if the version has been updated
 
.DESCRIPTION
    This script checks for the current version of some common software from their internet URLs.  It then checks a local file for the stored software version.  If the two don't match,
    an email will be sent notifying of the new version number.  The stored version number will then be updated for future version checking.
    Currently software list:
    Adobe Flash Player
    Adobe Acrobat Reader DC
    Java Runtime
    Notepad++
    Paint.net
    PDFCreator
 
.PARAMETER To
    The "To" email address for notifications
 
.PARAMETER From
    The "From" email address for notifications
 
.PARAMETER Smtpserver
    The smtpserver name for email notifications
 
.PARAMETER SoftwareVersionsFile
    The location of the file used to store the software versions
 
.EXAMPLE
    Check-SoftwareVersions.ps1
    Checks the internet URLs of common software for the current version number and sends an email if a new version has been released.
 
.NOTES
    Script name: Check-SoftwareVersions.ps1
    Author:      Developed by Rhys Saddul - Original script template created by Trevor Jones
    Link:        https://smsagent.blog/2015/06/24/checking-for-new-versions-of-common-software-with-powershell/
 
#>
 
 
[CmdletBinding(SupportsShouldProcess=$True)]
    param
        (
        [Parameter(Mandatory=$False, HelpMessage="The 'to' email address")]
            [string]$To="rsaddul@hcuc.ac.uk",

        [Parameter(Mandatory=$False, HelpMessage="The 'from' email address")]
            [string]$From="rhys.saddul@gmail.com",

        [Parameter(Mandatory=$False, HelpMessage="The 'SmtpServer' address")]
            [string]$SmtpServer="smtp.gmail.com",

        [Parameter(Mandatory=$False, HelpMessage="The 'Port' Number")]
            [string]$SmtpPort = "587",

        [Parameter(Mandatory=$False, HelpMessage="The 'Encrytion' method")]
            [string]$SmtpSsl = "True",

        [parameter(Mandatory=$False, HelpMessage="The location of the software versions file")]
            [string]$SoftwareVersionsFile="C:\SoftwareVersions.txt"
        )
 
 
$EmailParams = @{
    To = $To
    From = $From
    Smtpserver = $SmtpServer
    SmtpPort = $SmtpPort
    SmtpSsl = $SmtpSsl
    }
 
# Note: to find the element that contains the version number, output all elements to gridview and search with the filter, eg:
# $URI = "https://notepad-plus-plus.org/"
# $HTML = Invoke-WebRequest -Uri $URI

#PowerShell GridView, then use the criteria filters to find the element you want:
$HTML.AllElements | Out-Gridview
 
 
  
##############
# Notepad ++ #
##############
 
Write-Verbose "Checking Notepad++"
$URI = "http://notepad-plus-plus.org/"
$HTML = Invoke-WebRequest -Uri $URI
$NewNotepadVersion = (($HTML.AllElements | where {$_.innerHTML -like "Current Version *.*.*"}).innerHTML).Split(" ")[2]
Write-Verbose "Found version: $NewNotepadVersion"
 
$CurrentNotepadVersion = ((Get-Content $SoftwareVersionsFile | Select-string "Notepad\+\+").ToString()).Substring(11)
Write-Verbose "Stored version: $CurrentNotepadVersion"
 
If ($NewNotepadVersion -ne $CurrentNotepadVersion)
    {
        Write-Verbose "Sending email"
        Send-MailMessage @EmailParams -Subject "Notepad++ Update" -Body "Notepad++ has been updated from $CurrentNotepadVersion to $NewNotepadVersion"
        write-verbose "Setting new stored version number for Notepad++"
        $Content = Get-Content $SoftwareVersionsFile
        $NewContent = $Content.Replace("Notepad++: $CurrentNotepadVersion","Notepad++: $NewNotepadVersion")
        $NewContent | Out-File $SoftwareVersionsFile -Force
    }
 
 

