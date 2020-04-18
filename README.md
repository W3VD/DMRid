"# DMRid"

Files:
1. CreateDMRidSchema.sql - Microsoft TSQL script that creates database, table, and views
2. DMRid.ps1 - Main script to run
3. outdatatable.ps1 - Powershell function used to convert Powershell Objects to Powershell Datatable
4. sql.ps1 - Usefull SQL powershell functions developed by moya034

PreRequisites:
1. Working install of Microsoft SQL Server (SQL Server Express is available for free from Microsoft's website)
2. ProScan installed @ C:\ProScan. If ProScan is not installed, comment out lines 26,27,30,31 in DMRid.ps1
3. If Using Networked SQL Server edit $server variable in DMRid.ps1 line 6 in DMRid.ps1
4. If Using SQL Server Express, install on same computer where you will run the script

Install:
1. cd C:\
2. git clone https://github.com/moya034/DMRid/
3. mkdir C:\temp
4. Run C:\DMRid\CreateDMRidSchema.sql in MS SQL Administrator
5. powershell.exe C:\DMRid\DMRid.ps1
