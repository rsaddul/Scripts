<#

Developed by: Rhys Saddul

#>

# Install MicrosoftTeams module if not already installed

if (-not (Get-Module -Name "MicrosoftTeams" -ListAvailable)) {
    Install-Module -Name "MicrosoftTeams" -Force
}

# Prompt to ensure varibles have been setup correctly prior to running the script
$dialogResult = [System.Windows.Forms.MessageBox]::Show("Have you set the varibles?", "Variable Setup", "YesNo", "Question")
if ($dialogResult -eq "Yes") {
    Write-Host "User confirmed variables have been set. Proceeding with the script." -ForegroundColor Green
} else {
    Write-Host "User confirmed Variables have not been set. Exiting the script." -ForegroundColor Red
    return
}

$CSVFile = "C:\TeamCreationTemplate.csv"
 
Try {
    #Read the CSV File
    $TeamsCSV = Import-CSV -Path $CSVFile
 
    #Connect to Microsoft Teams
    Connect-MicrosoftTeams
 
    #Iterate through the CSV 
    ForEach($Team in $TeamsCSV)
    {
        Try {
            #Create a New Team
            Write-host -f Yellow "Creating Team:" $Team.TeamName
            $NewTeam = New-Team -DisplayName $Team.TeamName -Owner $Team.Owner -Description $Team.Description -Visibility $Team.Visibility -Template EDU_Class -ErrorAction Stop
            Write-host "`tNew Team '$($Team.TeamName)' Created Successfully" -f Green
 
            #Add Members to the Team
            Write-Host "`tAdding Team members..." -f Yellow
            $Members = $Team.Members.Split(";")
            ForEach($Member in $Members)
            {
                Add-TeamUser -User $Member -GroupId $NewTeam.GroupID -Role Member
                Write-host "`t`tAdded Team Member:'$($Member)'" -f Green
            }
        }
        Catch {
            Write-host -f Red "Error Creating Team:" $_.Exception.Message
        }
    }
}
Catch {
    Write-host -f Red "Error:" $_.Exception.Message
}