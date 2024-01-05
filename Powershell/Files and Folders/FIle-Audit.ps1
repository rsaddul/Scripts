# Firstly we will scan the local HDD and save the file list as a variable
$LocalPDFs = Get-ChildItem -Path "C:\" *.pdf -Recurse
$LocalNames = ( $LocalPDFs | select Name, Directory)

# Now lets import the list of missing files from a CSV
$MissingFiles = Import-Csv -Path '\\ad.glfschools.org\library\Packages\PSF-File-Audit\Script\PSF-MissingFiles.csv'

# Let's set the computername to a variable for use when auditing
$LocalComp = $env:computername
$OutputFileName = ("$LocalComp"+"-MissingFileAudit.txt")

# Run checks to see if the missing file names are present on the local device
ForEach ($MissingFile in $MissingFiles) {
$FileName = $MissingFile.NAME

If ($LocalNames -contains $FileName) {"SUCCESS - Filename $FileName is located on this device, see file log at end for location" | Out-File -FilePath ".\$OutputFileName" -Append}
else 
{"FALSE - Filename $FileName is not present" | Out-File -FilePath ".\$OutputFileName" -Append}
}
"Local PDF file log:" | Out-File -FilePath ".\$OutputFileName" -Append
$LocalNames | ft | Out-File -FilePath ".\$OutputFileName" -Append

# Export Results
$OutputLocation = ("\\ad.glfschools.org\library\Packages\PSF-File-Audit\Reports" + "$OutputFileName")
Move-Item ".\$OutputFileName" "$OutputLocation"