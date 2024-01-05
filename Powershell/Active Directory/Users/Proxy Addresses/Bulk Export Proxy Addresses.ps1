# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Prompt the user to enter the distinguished name of the OU to search in
$searchBase = "OU=IT,OU=Staff,OU=Users,OU=[SiteName],OU=--------------------SandboxAD--------------------,OU=HCUC V2 (TEST),DC=resource,DC=uc"

# Get the users in the specified OU and their proxy addresses
$users = Get-ADUser -Filter * -SearchBase $searchBase -Properties proxyAddresses,samAccountName

# Determine the maximum number of proxy addresses among all the users
$maxProxyCount = 0
foreach ($user in $users) {
    if ($user.proxyAddresses.Count -gt $maxProxyCount) {
        $maxProxyCount = $user.proxyAddresses.Count
    }
}

# Create a new Excel workbook and worksheet
$excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.Add()
$worksheet = $workbook.Worksheets.Item(1)

# Set the column headings
$worksheet.Cells.Item(1,1) = "User"
$worksheet.Cells.Item(1,2) = "samAccountName"
$worksheet.Cells.Item(1,3) = "Proxy Address 1"
for ($i = 2; $i -le $maxProxyCount; $i++) {
    $worksheet.Cells.Item(1,$i+2) = "Proxy Address $($i)"
}

# Write the users' names, samAccountName, and proxy addresses to the worksheet
$row = 2
foreach ($user in $users) {
    $worksheet.Cells.Item($row,1) = $user.Name
    $worksheet.Cells.Item($row,2) = $user.samAccountName
    $proxyAddresses = $user.proxyAddresses
    $proxyAddress1 = $proxyAddresses | Where-Object { $_.StartsWith("SMTP") }
    if ($proxyAddress1 -ne $null) {
        $worksheet.Cells.Item($row,3) = $proxyAddress1
        $proxyAddresses = $proxyAddresses | Where-Object { $_ -ne $proxyAddress1 }
    }
    for ($i = 0; $i -lt $proxyAddresses.Count; $i++) {
        $worksheet.Cells.Item($row,$i+4) = $proxyAddresses[$i]
    }
    for ($i = $proxyAddresses.Count; $i -lt $maxProxyCount-1; $i++) {
        $worksheet.Cells.Item($row,$i+4) = ""
    }
    $row++
}

# Autofit the columns
$range = $worksheet.UsedRange
$range.EntireColumn.AutoFit() | Out-Null

# Save the workbook
$workbook.SaveAs("Proxy Addresses.xlsx")

# Close the workbook and Excel
$workbook.Close($true)
$excel.Quit()
