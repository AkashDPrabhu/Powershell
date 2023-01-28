
$date = $((get-date).ToString('dd-MM-yyyy-hh-mm-tt'))

#$ADencrpt = "01000000d08c9ddf0115d1118c7a00c04fc297eb010000006f3575fbf57ecc4fa597ab3ad048b0640000000002000000000003660000c000000010000000e5486295829ff8c9a31756c681e838a80000000004800000a0000000100000004f5b366ac80208653862167dd798951220000000126d3a439e3805505e41d00d5c9f42b94cc8f72eb2e3cfb7744ae526756678bc1400000077b5b24ccb709fe68c5c58085cc001c5ff0f413f"
$username = “superadmin@nbtdc.local”
$password1 = ConvertTo-SecureString "IT@admin2k18" -AsPlainText -Force
#$password1 = ConvertTo-SecureString -string $ADencrpt 
$ad = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password1)
$Serverlist=Invoke-Command 	-ComputerName 192.168.21.123 -ScriptBlock {get-adcomputer -filter * -properties IPv4Address | select IPv4Address -expandproperty IPv4Address | Sort-Object "IPv4Address"} -credential	$ad

foreach($server in $Serverlist)
{
Invoke-Command 	-ComputerName	$server	 -ScriptBlock {gwmi Win32_logicaldisk -filter "drivetype = 3" | Select DeviceID, @{Name="Size(GB)";Expression={[decimal]("{0:N0}" -f($_.size/1gb))}}, @{Name="Free Space(GB)";Expression={[decimal]("{0:N0}" -f($_.freespace/1gb))}}, @{Name="Free (%)";Expression={"{0,6:P0}" -f(($_.freespace/1gb) / ($_.size/1gb))}}} -credential $ad  | export-csv "C:\DiskSpaceReport\DiskSpaceReportLog\DiskSpaceReport$date.CSV" -append	
}
#Mail Body
$day = (Get-Date).ToString('dd-MM-yyyy')
$monthname = ((Get-Culture).DateTimeFormat).GetMonthName((Get-Date).Month)  
$year=get-date -format -yyyy





# Continue even if there are errors 
$ErrorActionPreference = "Continue"; 
 
# Set your warning and critical thresholds 
$percentWarning = 30; 
$percentCritcal = 20; 
 
# REPORT PROPERTIES 
 # Path to the report 
  $reportPath = "C:\DiskSpaceReport\HTML\"; 
 
 # Report name 
  $reportName = "DiskSpaceRpt_$date.html"; 
 
# Path and Report name together 
$diskReport = $reportPath + $reportName 
 
#Set colors for table cell backgrounds 
$redColor = "#FF0000" 
$orangeColor = "#FBB917" 
$whiteColor = "#FFFFFF" 

 
# Get computer list to check disk space 

$datetime = Get-Date -Format "MM-dd-yyyy_HH"; 
 

# Create and write HTML Header of report 
$titleDate = get-date -uformat "%m-%d-%Y - %A" 
$header = " 
  <html> 
  <head> 
  <meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'> 
  <title>DiskSpace Report</title> 
  <STYLE TYPE='text/css'> 
  <!-- 
  td { 
   font-family: Calibri; 
   font-size: 12px; 
   border-top: 1px solid #999999; 
   border-right: 1px solid #999999; 
   border-bottom: 1px solid #999999; 
   border-left: 1px solid #999999; 
   padding-top: 0px; 
   padding-right: 0px; 
   padding-bottom: 0px; 
   padding-left: 0px; 
  } 
  body { 
   margin-left: 5px; 
   margin-top: 5px; 
   margin-right: 0px; 
   margin-bottom: 10px; 
   table { 
   border: thin solid #000000; 
  } 
  --> 
  </style> 
  </head> 
  <body> 
  <table width='100%'> 
  <tr bgcolor='#548DD4'> 
  <td colspan='7' height='30' align='center'> 
  <font face='calibri' color='#003399' size='4'><strong>Daily Disk Report for $titledate</strong></font> 
  </td> 
  </tr> 
  </table> 
" 
 Add-Content $diskReport $header 
 
# Create and write Table header for report 
 $tableHeader = " 
 <table width='100%'><tbody> 
 <tr bgcolor=#548DD4> 
 <td width='10%' align='center'>PSComputerName</td>
 <td width='10%' align='center'>DeviceID</td> 
 <td width='10%' align='center'>Size</td>
  <td width='10%' align='center'>Free_Space</td>
   <td width='10%' align='center'>percentFree</td>
 </tr> 
" 
Add-Content $diskReport $tableHeader 
 $csv = Import-Csv "C:\DiskSpaceReport\DiskSpaceReportLog\DiskSpaceReport$date.CSV" | Sort-Object "Free (%)"
 foreach($item in $csv) 
 {         
  $DeviceID=$($item.DeviceID)
  $Size=$($item.'Size(GB)')
  $Free_Space =$($item.'Free Space(GB)')
  $percentFree=$($Free_Space/$Size*100)
  $PSComputerName=$($item.PSComputerName)
  
# Set background color to Orange if just a warning 
    $color=$whiteColor
 if($percentFree -lt $percentWarning)       
  { 
    $color = $orangeColor  
 }
# Set background color to Orange if space is Critical 
      if($percentFree -lt $percentCritcal) 
        { 
        $color = $redColor 
       }         
  
 # Create table data rows  
    $dataRow = " 
  <tr> 
        <td width='10%'>$PSComputerName</td> 
  <td width='5%' align='center'>$DeviceID</td> 
  <td width='5%' align='center'>$Size</td> 
  <td width='5%' align='center'>$Free_Space</td> 
    <td width='5%' bgcolor=`'$color`' align='center'>$percentFree</td> 
 
  </tr> 
" 
if($percentFree -lt $percentWarning)       
  { 
Add-Content $diskReport $dataRow; 
}

} 
 
   

# Create table at end of report showing legend of colors for the critical and warning 
 $tableDescription = " 
 </table><br><table width='20%'> 
 <tr bgcolor='White'> 
    <td width='10%' align='center' bgcolor='#FBB917'>Critical less than 30% free space</td> 
 <td width='10%' align='center' bgcolor='#FF0000'>Critical less than 20% free space</td> 
 </tr> 
" 


#$SecurePassword=ConvertTo-SecureString 'Password' –asplaintext –force 
#$SecurePassword | ConvertFrom-SecureString



#Email Attachment

#$encrypted = "01000000d08c9ddf0115d1118c7a00c04fc297eb010000006f3575fbf57ecc4fa597ab3ad048b0640000000002000000000003660000c000000010000000c644646ac393ee7a1b4a8866476446d00000000004800000a00000001000000007e9cc98dd75707655d668bc09e9a50b1800000096182cd2cc6f7aa007e5c7415965969b8923fa2f34d79b9214000000a7f0db24714febbac3a08d0814aa3848a5986e7c"
$attachmentpath = "C:\DiskSpaceReport\DiskSpaceReportLog\DiskSpaceReport$date.CSV"

if(test-path $attachmentpath)
{
$EmailTo = "infrateam@paynearby.in,noc.windows@locuz.com,noc.dbteam@locuz.com" 
$EmailFrom = "helpdesk@paynearby.in" 
$EmailPW = $EmailPassword
$Subject = "Daily Disc space Report" 
$Body = "" 
$Attachment = New-Object System.Net.Mail.Attachment($attachmentpath)
$SMTPServer = "192.168.21.164" 
$SMTPPort = 25
$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
$attachment = New-Object System.Net.Mail.Attachment($attachmentpath, 'text/plain')
$SMTPMessage.Attachments.Add($attachment)
$SMTPMessage.IsBodyHTML = $true 
$SMTPMessage.Body = "<head><pre>$style</pre></head>" 
$SMTPMessage.Body += Get-Content $diskReport 
$SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer, $SMTPPort)  
$SMTPClient.EnableSsl = $false 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($EmailFrom, $EmailPW);  
$SMTPClient.Send($SMTPMessage) 
}

