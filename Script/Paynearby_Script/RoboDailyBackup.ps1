

$date = $((get-date).ToString('dd-MM-yyyy'))
$prevday=$((get-date).AddDays(-1))
$prevdate=$(($prevday).ToString('dd MMM yyyy'))
$prevdate1=$(($prevday).ToString('yyyy-MM-dd'))
$Month = $((get-date).ToString('MMM yyyy'))
$dir= "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month" 
Start-Transcript -path C:\DailyBackup\Log\Dailybackup_$date.txt

Send-MailMessage -To infrateam@paynearby.in -from helpdesk@paynearby.in -Subject "Backup process: Initiated for $date" -Body 'Dear team, Kindly wait for backup confirmation' -SmtpServer 192.168.21.164
Send-MailMessage -To noc.windows@locuz.com -from helpdesk@paynearby.in -Subject "Backup process: Initiated for $date" -Body 'Dear team, Kindly wait for backup confirmation' -SmtpServer 192.168.21.164
Send-MailMessage -To pavankumar.joshi@locuz.com -from helpdesk@paynearby.in -Subject "Backup process: Initiated for $date" -Body 'Dear team, Kindly wait for backup confirmation' -SmtpServer 192.168.21.164
Send-MailMessage -To noc.dbteam@locuz.com -from helpdesk@paynearby.in -Subject "Backup process: Initiated for $date" -Body 'Dear team, Kindly wait for backup confirmation' -SmtpServer 192.168.21.164
Send-MailMessage -To rajakrishnan.rg@locuz.com -from helpdesk@paynearby.in -Subject "Backup process: Initiated for $date" -Body 'Dear team, Kindly wait for backup confirmation' -SmtpServer 192.168.21.164


New-Item -Path "$dir" -Name "$date" -ItemType "directory"
New-Item -Path "$dir\$date\" -Name "MySQLProdDB Backup $date" -ItemType "directory"
New-Item -Path "$dir\$date\" -Name "AuthDB Backup $date" -ItemType "directory"
New-Item -Path "$dir\$date\" -Name "WhiteLabeDB Backup $date" -ItemType "directory"
New-Item -Path "$dir\$date\" -Name "TranscorpDB Backup $date" -ItemType "directory"


#New-Item -Path "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.115" -Name "$Month" -ItemType "directory"
#New-Item -Path "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.77" -Name "$Month" -ItemType "directory"
#New-Item -Path "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.156" -Name "$Month" -ItemType "directory"
#New-Item -Path "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.116" -Name "$Month" -ItemType "directory"
#New-Item -Path "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.92" -Name "$Month" -ItemType "directory"
#New-Item -Path "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.131" -Name "$Month" -ItemType "directory"

#New-Item -Path "\\192.168.21.195\AEPS_Logs\AEPS_DBBackup\" -Name "$Month" -ItemType "directory"
#New-Item -Path "\\192.168.21.195\AEPS_Logs\AEPS_DBBackup\$Month\" -Name "$date" -ItemType "directory"
#New-Item -Path "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.156\$Month" -Name "$prevdate1" -ItemType "directory"
#New-Item -Path "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.115\$Month" -Name "$prevdate1" -ItemType "directory"
#New-Item -Path "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.116\$Month" -Name "$prevdate1" -ItemType "directory"
#New-Item -Path "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.92\$Month" -Name "$prevdate1" -ItemType "directory"
#New-Item -Path "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.131\$Month" -Name "$prevdate1" -ItemType "directory"


#Robocopy "\\192.168.29.115\d$\ServerLog\$prevdate1"                        "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.115\$Month\$prevdate1" /S /E /R:0 /mov
#Robocopy "\\192.168.29.116\d$\ServerLog\$prevdate1"                        "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.116\$Month\$prevdate1" /S /E /R:0 /mov
#Robocopy "\\192.168.29.77\d$\ServerLog\$prevdate1"                        "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.77\$Month\$prevdate1" /S /E /R:0 /mov
#Robocopy "\\192.168.29.156\d$\ServerLog\$prevdate1"                        "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.156\$Month\$prevdate1" /S /E /R:0 /mov
#Robocopy "\\192.168.29.92\d$\ServerLog\$prevdate1"                        "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.92\$Month\$prevdate1" /S /E /R:0 /mov
#Robocopy "\\192.168.29.131\d$\ServerLog\$prevdate1"                        "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.131\$Month\$prevdate1" /S /E /R:0 /mov

Robocopy "\\172.21.0.12\h$\Auto Backup\Daily backup"        "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date" /R:0 /mov
Robocopy "\\172.21.0.12\h$\Auto Backup\HistoryDB BKP"       "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date" /R:0 /mov
Robocopy "\\172.21.0.12\h$\Auto Backup\Daily backup\UtilityDB"       "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date" /R:0 /mov
Robocopy "\\192.168.31.12\d$\BACKUP"                          "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date\AuthDB Backup $date" /R:0 /mov
Robocopy "\\192.168.31.13\d$\Backup"                          "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date\WhiteLabeDB Backup $date" /R:0 /mov
Robocopy "\\192.168.31.14\d$\Daily Backup"                    "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date" /R:0 /mov
Robocopy "\\192.168.31.15\d$\Backup"                          "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date\TranscorpDB Backup $date" /R:0 /mov
Robocopy "\\172.21.0.13\d$\Backup"                          "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date" /R:0 /mov
Robocopy "\\172.21.0.13\d$\HistoryLog"                      "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date" /R:0 /mov
Robocopy "\\192.168.31.34\d$\BACKUP"                     "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date" /R:0 /mov
Robocopy "\\192.168.31.19\d$\Backup"                          "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date" /R:0 /mov
Robocopy "\\192.168.31.17\d$\FlightBackup\Full"               "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date" /R:0 /mov
Robocopy "\\192.168.31.17\d$\TrainDBBackup\Full"               "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date" /R:0 /mov
Robocopy "\\172.21.0.17\d$\DailyBackup"                          "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date\MySQLProdDB Backup $date" /R:0 /mov


#& 'C:\Program Files\7-Zip\7z.exe' a -t7z -mx=9 "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.131\$Month\$prevdate1.7z"  "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.131\$Month\$prevdate1\" -sdel

#& 'C:\Program Files\7-Zip\7z.exe' a -t7z -mx=9 "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.115\$Month\$prevdate1.7z"  "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.115\$Month\$prevdate1\" -sdel

#& 'C:\Program Files\7-Zip\7z.exe' a -t7z -mx=9 "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.116\$Month\$prevdate1.7z"  "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.116\$Month\$prevdate1\" -sdel

#& 'C:\Program Files\7-Zip\7z.exe' a -t7z -mx=9 "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.77\$Month\$prevdate1.7z"  "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.77\$Month\$prevdate1\" -sdel

#& 'C:\Program Files\7-Zip\7z.exe' a -t7z -mx=9 "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.156\$Month\$prevdate1.7z"  "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.156\$Month\$prevdate1\" -sdel

#& 'C:\Program Files\7-Zip\7z.exe' a -t7z -mx=9 "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.92\$Month\$prevdate1.7z"  "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.92\$Month\$prevdate1\" -sdel

& 'C:\Program Files\7-Zip\7z.exe' a -t7z -mx=9 "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date\AuthDB Backup $date.7z" "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date\AuthDB Backup $date\" -sdel

& 'C:\Program Files\7-Zip\7z.exe' a -t7z -mx=9 "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date\WhiteLabeDB Backup $date.7z" "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date\WhiteLabeDB Backup $date\" -sdel

& 'C:\Program Files\7-Zip\7z.exe' a -t7z -mx=9 "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date\TranscorpDB Backup $date" "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date\TranscorpDB Backup $date\" -sdel

& 'C:\Program Files\7-Zip\7z.exe' a -t7z -mx=9 "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date\MySQLProdDB Backup $date" "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date\MySQLProdDB Backup $date\" -sdel



$Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@
#[string]$Body1 = Get-Childitem -path  "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.131\$Month\$prevdate1.7z" | Select-Object fullname,Name, @{Name="Size(MB)";Expression={ "{0:N0}" -f ($_.Length / 1MB) }} | ConvertTo-Html  -Head $Header
#[string]$Body2 = Get-Childitem -path  "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.115\$Month\$prevdate1.7z" | Select-Object fullname,Name, @{Name="Size(MB)";Expression={ "{0:N0}" -f ($_.Length / 1MB) }} | ConvertTo-Html  -Head $Header
#[string]$Body3 = Get-Childitem -path  "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.116\$Month\$prevdate1.7z" | Select-Object fullname,Name, @{Name="Size(MB)";Expression={ "{0:N0}" -f ($_.Length / 1MB) }} | ConvertTo-Html  -Head $Header
#[string]$Body4 = Get-Childitem -path  "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.77\$Month\$prevdate1.7z" | Select-Object fullname,Name, @{Name="Size(MB)";Expression={ "{0:N0}" -f ($_.Length / 1MB) }} | ConvertTo-Html  -Head $Header
#[string]$Body5 = Get-Childitem -path  "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.156\$Month\$prevdate1.7z" | Select-Object fullname,Name, @{Name="Size(MB)";Expression={ "{0:N0}" -f ($_.Length / 1MB) }} | ConvertTo-Html -Head $Header
#[string]$Body6 = Get-Childitem -path  "\\192.168.21.195\AEPS_Logs\AEPS_Logs_29.92\$Month\$prevdate1.7z" | Select-Object fullname,Name, @{Name="Size(MB)";Expression={ "{0:N0}" -f ($_.Length / 1MB) }} | ConvertTo-Html  -Head $Header
[string]$Body7 = Get-Childitem -path  "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date\" | Select-Object fullname,Name, @{Name="Size(MB)";Expression={ "{0:N0}" -f ($_.Length / 1MB) }} | ConvertTo-Html  -Head $Header
[string]$Body8 = Get-Childitem -path  "\\192.168.21.195\DailyArchiveDBBackup\DAILY BACKUP\$Month\$date\" | Measure-Object -Property Length -Sum |Select-Object @{Name="Size(GB)";Expression={("{0:N2}" -f($_.Sum/1GB))}},Count | ConvertTo-Html  -Head $Header



Stop-Transcript

Send-MailMessage -from helpdesk@paynearby.in -To "infrateam@paynearby.in","noc.windows@locuz.com","pavankumar.joshi@locuz.com","noc.dbteam@locuz.com","rajakrishnan.rg@locuz.com","karthik.mani@paynearby.in" -Subject "Backup process: Completed for $date" -Body "Dear team, <br>Backup process Completed <br> $body1 <br>$body2 <br>$body3 <br> $body4 <br>$body5 <br>$body6 <br>$body7 <br><br>Below is count and Sum of Database backup:<br>$body8 <br>" -BodyAsHtml -SmtpServer "192.168.21.164" -Port "25" 

