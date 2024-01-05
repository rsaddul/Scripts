# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Prompt the user to enter the username
$username = Read-Host "Enter the username"

# Get the user and their proxy addresses
$user = Get-ADUser -Identity $username -Properties proxyAddresses
$proxyAddresses = $user.proxyAddresses

# Create a new Excel workbook and worksheet
$excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.Add()
$worksheet = $workbook.Worksheets.Item(1)

# Set the column headings
$worksheet.Cells.Item(1,1) = "User"
$i = 1
foreach ($proxyAddress in $proxyAddresses) {
    $worksheet.Cells.Item(1,$i+1) = "Proxy Address $($i)"
    $i++
}

# Write the user's name and proxy addresses to the worksheet
$row = 2
$worksheet.Cells.Item($row,1) = $user.Name
$i = 1
foreach ($proxyAddress in $proxyAddresses) {
    $worksheet.Cells.Item($row,$i+1) = $proxyAddress
    $i++
}

# Autofit the columns
$range = $worksheet.UsedRange
$range.EntireColumn.AutoFit() | Out-Null

# Save the workbook
$workbook.SaveAs("$username Proxy Addresses.xlsx")

# Close the workbook and Excel
$workbook.Close($true)
$excel.Quit()
