$CSVFile = "C:\Users\RhysSaddul\Downloads\TeamsCreation.csv"
 
Try {
    $TeamsData = Import-CSV -Path $CSVFile
    Connect-MicrosoftTeams
 
    ForEach($Team in $TeamsData) {
        Try {
            Write-Host -f Yellow "Creating Team:" $Team.TeamName

            # Only include -Owner if value present
            if ([string]::IsNullOrWhiteSpace($Team.Owner)) {
                $NewTeam = New-Team -DisplayName $Team.TeamName -Description $Team.Description -Visibility $Team.Visibility -ErrorAction Stop
            } else {
                $NewTeam = New-Team -DisplayName $Team.TeamName -Owner $Team.Owner -Description $Team.Description -Visibility $Team.Visibility -ErrorAction Stop
            }

            Write-Host "`tNew Team '$($Team.TeamName)' Created Successfully" -f Green
 
            # Add Members if provided
            if (-not [string]::IsNullOrWhiteSpace($Team.Members)) {
                Write-Host "`tAdding Team members..." -f Yellow
                $Members = $Team.Members -split ";"
                ForEach($Member in $Members) {
                    if (-not [string]::IsNullOrWhiteSpace($Member)) {
                        Add-TeamUser -User $Member.Trim() -GroupId $NewTeam.GroupID -Role Member
                        Write-Host "`t`tAdded Team Member:'$($Member)'" -f Green
                    }
                }
            } else {
                Write-Host "`tNo members listed." -f DarkYellow
            }
        }
        Catch {
            Write-Host -f Red "Error Creating Team:" $_.Exception.Message
        }
    }
}
Catch {
    Write-Host -f Red "Error:" $_.Exception.Message
}
