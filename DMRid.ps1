# Import Functions
. C:\DMRid\sql.ps1
. C:\DMRid\outdatatable.ps1

# SQL Variables - Use only one connection string!
$server = '127.0.0.1'
$database = 'DMR'
$sqlConnection = "Data Source=$server;Integrated Security=SSPI;Initial Catalog=$database" # Integrated Windows authentication
#$sqlConnection = "Server=$server;Database=$database;User ID=XXXX;Password=XXXX" # SQL Authetication

# File Path Variables
$downfile = 'C:\temp\user.csv'
$outfile = 'C:\temp\UID Lookup.txt'
$proscanfile = 'C:\ProScan\UID Lookup.txt'
$anytonefile = 'C:\DMRid\anytoneContacts.csv'

# Download new DMR database file
Invoke-WebRequest -Uri 'https://www.radioid.net/static/user.csv' -OutFile $downfile

# Import CSV file, convert to Powershell Data Table, truncate table of old data, and use SQL BulkCopy function to upload new data
$dataImport = Import-Csv -Path $downfile | Out-DataTable
$returnCode = executeStoredProcedure $sqlConnection 'TRUNCATE TABLE [DMR].[dbo].[user]'
$returnCode = BulkCopy $sqlConnection '[DMR].[dbo].[user]' $dataImport

# Query the ProScan SQL View and Export CSV file without double quotes, copy to ProScan dir
selectQuery $sqlConnection 'SELECT [#SQL] FROM [dbo].[proscan]' | ConvertTo-Csv -NoTypeInformation | % {$_.Replace('"','')} | Out-File $outfile
Copy-Item -Path $outfile -Destination $proscanfile -Force

# Clean Up our mess
Remove-Item -Path $downfile
Remove-Item -Path $outfile

# Export Anytone 878 Digital Contact List
$anytoneSQL = 'SELECT [No.]
                      ,[Radio ID]
                      ,[Callsign]
                      ,[Name]
                      ,[City]
                      ,[State]
                      ,[Country]
                      ,[Remarks]
                      ,[Call Type]
                      ,[Call Alert]
                  FROM [DMR].[dbo].[anytone]'

selectQuery $sqlConnection $anytoneSQL | Export-Csv -Path $anytonefile -NoTypeInformation -Force