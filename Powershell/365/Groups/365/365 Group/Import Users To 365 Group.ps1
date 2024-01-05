#Install Module
Install-Module -Name ExchangeOnlineManagement

#Get Credentials to connect
Connect-ExchangeOnline

#This will remove a member for testing purposes
#Remove-DistributionGroupMember -Identity psftest -Member j.matthews1@glfschools.org -Confirm:$false

#Define Variables and array

$import = Get-ChildItem "C:\Users\Rhys's Desktop\Desktop\New Scripts\365 Group" | Where-Object {$_.Extension -like "*.csv"}

$import | ForEach-Object {
$file = $_.FullName
$filename = $_.name

    $UsersList = Import-CSV $file
    $failedUsers = @()
    $usersAlreadyExist =@()
    $successUsers = @()
    $VerbosePreference = "Continue"
    $LogFolder = "C:\temp"

    #This will checek each user in the userlist csv, it will add them to the distrbution list and display warnings if they are already a member or it cant add them. 
    #You will also get a message to tell you if it has been successful. These will be stored in three log files mentioned near the bottom of the script.

    ForEach($User in $UsersList)
    {

    try {
    
        if (!((Get-UnifiedGroupLinks -Identity $user.groupid -LinkType Members).PrimarySmtpAddress -contains $user.member)){ 
            Add-UnifiedGroupLinks -Identity $user.groupid -LinkType Members -Links $user.member -erroraction stop
            Write-Verbose "[PASS] Added $user.member to group $user.groupid"
            $successUsers += $user.member

        }

        else {
            Write-Warning "[WARNING] $user.member already exists in Distribution Group $user.groupid"
            $usersAlreadyExist += $user.member
        }
    }
    catch {
        Write-Warning "[ERROR]Can't add $user.member to $user.groupid"
        $failedUsers += $user.member
        }
    }

    if ( !(test-path $LogFolder)) {
        Write-Verbose "Folder [$($LogFolder)] does not exist, creating"
        new-item $LogFolder -Force 
    }

    #Here is where the logs for failerd users, users that are already memebers and succesful user accounts are added to the logs. 
    #Please check variables $logfolder location to see the file path.

    Write-verbose "Writing logs"
    $failedUsers | out-file -FilePath  "$LogFolder\$filename FailedUsers.log" -Force -Verbose
    $usersAlreadyExist | out-file -FilePath  "$LogFolder\$filename usersAlreadyExist.log" -Force -Verbose
    $successUsers | out-file -FilePath  "$LogFolder\$filename successUsers.log" -Force -Verbose
}