############################
# Developed by Rhys Saddul # 
############################

# The CSV file should have the following columns: Username, ProxyAddresses, and PrimaryEmailAddress. 
# The ProxyAddresses column should containt a semicolon-seperated list of proxy addresses.

Import-Module ActiveDirectory

# Get the path to the CSV file
$csvFile = Read-Host "Enter the path to the CSV file"

# Read the CSV file into a variable
$csvData = Import-Csv $csvFile

# Loop through each row in the CSV file
foreach ($row in $csvData) {
  # Get the user's distinguished name (DN)
  $dn = Get-ADUser -Filter "samAccountName -eq '$($row.Username)'" | Select-Object -ExpandProperty DistinguishedName

  # Get the current list of proxy addresses for the user
  $existingProxies = Get-ADUser -Identity $dn -Properties proxyAddresses | Select-Object -ExpandProperty proxyAddresses

  # Create an array to hold the new list of proxy addresses
  $newProxies = @()

  # Add each proxy address in the CSV file to the new list of proxy addresses
  foreach ($proxy in $row.ProxyAddresses) {
    $newProxies += "$proxy"
  }

  # Combine the existing proxy addresses with the new proxy addresses
  $newProxies += $existingProxies

  # Remove duplicate proxy addresses
  $newProxies = $newProxies | Select-Object -Unique

  # Update the user's proxy addresses
  Set-ADUser -Identity $dn -Replace @{proxyAddresses=$newProxies}

  # Set the user's primary email address
  Set-ADUser -Identity $dn -EmailAddress $row.PrimaryEmailAddress
}

Write-Host "All accounts updated successfully."

