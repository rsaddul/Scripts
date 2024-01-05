#Run the following cmdlet from target tenant

New-MigrationBatch -Name "Test Batch" -SourceEndpoint target_source_7977 -CSVData ([System.IO.File]::ReadAllBytes('users.csv')) -Autostart -TargetDeliveryDomain eduthing.onmicrosoft.com


#Get-Migrationednpoint

#Test-MigrationServerAvailability -EndPoint "Cross-Tenant Migration" -TestMailbox "rtest@eduthing.co.uk"
