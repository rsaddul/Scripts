############################
# Developed by Rhys Saddul #
############################

# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Define an array of AD groups to check
$ADGroups = @("Test", "Testt")

# Define an array of services to check
$Services = @("Spooler","PhoneSvc","Power")

# Create a variable to store the results
$Results = @()

# Loop through each AD group
foreach ($ADGroup in $ADGroups) {
    # Get the servers in the AD group
    $Servers = Get-ADGroupMember -Identity $ADGroup -Recursive |
        Where-Object { $_.objectClass -eq "computer" } |
        Select-Object -ExpandProperty Name

    # Loop through each server
    foreach ($Server in $Servers) {
        # Check if the server is online
        if (!(Test-Connection -ComputerName $Server -Count 1 -Quiet)) {
            # Add the result to the results array
            $Results += New-Object PSObject -Property @{
                Server = $Server
                Status = "Server Offline"
            }

            # Continue to the next server
            continue
        }

        # Loop through each service
        foreach ($Service in $Services) {
            # Use Invoke-Command to get the service status on the remote server
            $ServiceStatus = Invoke-Command -ComputerName $Server -ScriptBlock {
                Get-Service -Name $Using:Service
            }

            # Check if the service is running
            if ($ServiceStatus.Status -ne "Running") {
                # Use Invoke-Command to start the service on the remote server
                Invoke-Command -ComputerName $Server -ScriptBlock {
                    Start-Service $Using:ServiceStatus
                }

                # Add the result to the results array
                $Results += New-Object PSObject -Property @{
                    Server = $Server
                    Service = $Service
                    Status = "Service Started"
                }
            }
        }
    }
}

# Export the results to a CSV file
$Results | Export-Csv -Path "c:\Results.csv" -NoTypeInformation -Append
