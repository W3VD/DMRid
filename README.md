"# DMRid"

Files:
CreateDMRidSchema.sql - Microsoft TSQL script that creates datase, table, and views
DMRid.ps1 - Main script to run or schedule
outdatatable.ps1 - Powershell function used to convert Powershell Objects to Powershell Datatable
sql.ps1 - Usefull SQL powershell functions developed by moya034

PreRequisites:
1. Working install of Microsoft SQL Server (SQL Server Express is available for free from Microsoft's website)
2. ProScan installed @ C:\ProScan. If not comment out lines 26,27,30,31

Install:
cd C:\
git clone https://github.com/moya034/DMRid/
mkdir C:\temp
Run C:\DMRid\CreateDMRidSchema.sql in MS SQL Administrator

Usage:
If you are running a networked instance of MS SQL Server edit the $server variable in DMRid.ps1 with the server's hostname.
Otherwise, install SQL Server Express on the same computer that you will be running the script on.

Run:
powershell.exe C:\DMRid\DMRid.ps1
