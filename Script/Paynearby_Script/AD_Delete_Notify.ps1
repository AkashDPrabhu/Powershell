$lastweek = ((Get-Date).AddDays(-7)).ToString("yyyy-MM-dd")


$apiUrl = "https://hronemanagedapi.hrone.cloud/production/api/external/employees"
$header= 
@{
domainCode="nearby"
apiKey="nz9NRRyDgD1OYtHa4QnVH0PXIh96wGn0MfdDSb9cmtP"
'Content-Type'="application/json"
'Ocp-Apim-Subscription-Key'="b96f1ec0218145d39f1beb27e5b3182f" 
}

$Body= @"
{
"fromDateOfLeaving" :  "$lastweek",
"toDateOfLeaving" : "$lastweek",
"pagination":
	{
"pageNumber": 1,
"pageSize": 10000
}
}
"@


$users = Invoke-RestMethod -Body $Body -Headers $header -Uri $apiUrl -Method Post | select -ExpandProperty *
$gsuitepending= Get-GSUser -Filter *  | Where-Object { ($_.Suspended -eq $true)} | Select-Object User  -ExpandProperty user


If($users -ne $null)
{
       $mail = $Users.'work email'
             
    if($mail -ne $null)
        {

        $maillist=$mail.replace(".in",".in`n")
        $gspending=$gsuitepending.replace(".in",".in`n")

           Send-GmailMessage -From helpdesk@paynearby.in -To infrateam@paynearby.in -Subject "HROne Offboard - Notification" -Body  "Hi team, `nBelow members last working date $lastweek it has been one week from today. `nKindly take backup and delete the same in Gsuite.`n$maillist  `n`nPending list from Gsuite`n $gspending"
        }
      
}

