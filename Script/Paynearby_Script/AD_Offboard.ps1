$today = (Get-Date).ToString("yyyy-MM-dd")
$lastweek = ((Get-Date).AddDays(-30)).ToString("yyyy-MM-dd")

$logfile = "D:\HROne\HRONE_OFFBOARD.csv"
$logtime = Get-Date
Connect-SnipeitPS -URL 'http://nbtasset.paynearby.in' -apiKey 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMjk1ZTllMWQ1OGFmYTNlZWE0ZGEzYjQxZmI1NWQ5MjQyNzU4ZjZlMmQxZTExYjljZTZjMzA3MDMwMjE4NGM3YzkzODE1ODg1NmE2MjI3YTciLCJpYXQiOjE2NDIyMzEzOTcsIm5iZiI6MTY0MjIzMTM5NywiZXhwIjoyMTE1NjE2OTk2LCJzdWIiOiIzNzkiLCJzY29wZXMiOltdfQ.aubugi0yGWZbImno3ZuzSrj_Ut3SWVcHyG1VUZ1taqP4X7aK3USaVXxdnLlDWXRRZyEUG-WQAnayj38CaJUEq8rF9-om8lPEd0Hbj4laQd6YDmtZcUeqOg2ouMj7a_x1-GtjIu88cnuisI5svw6RslSsf47W9iKi0z_OXrdX-jeT7SjhrQJG-BejnUQng6F-3IKUfx-KnDSHZAPCsdKVqS-1tcjm4AQ49Ym1gdGlf2uKbta_DQ3-4tJOVX9Kmwj5TBkHVLIGvmG8oaPLT4Ph7IUHq2XTDaPK_t4Iuuqm-YocpCIBKyVF-TZmgkTuq5YBwxI6527-OuqgK33-IUVitQ5ov0WWjpllTIlkpwTyhhF2IwvW61VG7goH7fzMKGLn8lDgWEmFWYXLNeLrexr_cHnHxM_YcK8wI9KLIEgc7VIcCc8kxHzhMu_BZTyodifP1iay5lno0exmKU71ygn95KRUI1y8fpTECTE0cblkIxzfDlQRv4qI17FPCcQpPATAZulQ4x4BcHp5WVuJZ9aVPtsFoeMAE3_0BfBp0LUQ43cWWaDHEPo0akBcU-NCT6eMVsvT4EEGMnCdnEYlMMup3MIzXE77tMdvq7roQeTXVct09hYZ6v8zw2v3aw1l73p7L3VwJxOordh1AifSqYFbtyCWEHOwmH9d87-uoapTTIY'

$sheetId= "1i7tj4N6fy1YSsAaWmCJaZ_yGK0JKt4PWWBRL_QKpjwg"
$sheetname="Offboard" 

$recruiter = "sameer.virkud@paynearby.in", "akshay.rai@paynearby.in", "brijesh.kumar@paynearby.in", "vivekkumar.mishra@paynearby.in", "kathiravan.m@paynearby.in", "ramesh.thapa@paynearby.in"

$secpasswd = "01000000d08c9ddf0115d1118c7a00c04fc297eb0100000079372d9422e9d44e85d3040a3007c8ba0000000002000000000003660000c000000010000000124a735ebee711c96252a4d226e5c8080000000004800000a000000010000000b50fda0898da1dd4b49a16127e8538f110000000a51075aa46f9df2885e20585c538b650140000000902507ac7353e9ac07c12662387dcaf60c6917d" |Convertto-SecureString -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("appadmin@nbt.lan", $secpasswd)




if (!(Test-Path $logfile))
{
   New-Item -path $logfile
}

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
"toDateOfLeaving" : "$today",
"pagination":
	{
"pageNumber": 1,
"pageSize": 10000
}
}
"@


$users = Invoke-RestMethod -Body $Body -Headers $header -Uri $apiUrl -Method Post | select -ExpandProperty *


if(!(Test-NetConnection -ComputerName 10.0.0.20 -Port 389 -InformationLevel Quiet))
{
       Send-GmailMessage -From helpdesk@paynearby.in -To infrateam@paynearby.in -Subject "HROne-IT Onboarding | Failed" -Body "Failed to connect NBT.LAN - 192.168.21.2"
}

if(!(Test-NetConnection -ComputerName nbtdc.local -Port 389 -InformationLevel Quiet))
{
       Send-GmailMessage -From helpdesk@paynearby.in -To infrateam@paynearby.in -Subject "HROne-IT Onboarding | Failed" -Body "Failed to connect NBTDC.LOCAL - 192.168.21.100"
}

if(!(Get-GSuser ))
{
       Send-GmailMessage -From helpdesk@paynearby.in -To infrateam@paynearby.in -Subject "HROne-IT Onboarding | Failed" -Body "Failed to connect to Gsuite API"
}






If($users -ne $null)
{
foreach ($User in $users)
{

       $Username    = $User.'employee code'
       $mail = $User.'work email'

      
       #Check if the user account already exists in AD
       if (Get-ADUser -server '192.168.21.2' -Credential $mycreds -F {SamAccountName -eq $Username})
       {
       $statusA = Get-ADUser -server '192.168.21.2' -Filter 'SamAccountName -eq $Username' -Properties Enabled -Credential $mycreds |Select-Object Enabled -ExpandProperty Enabled


       $userid=Get-SnipeitUser -search $Username |select id -ExpandProperty id   
       $asset =Get-SnipeitAsset -user_id $userid |select name, asset_tag,serial,model,status_label,category|convertto-html
           
               
            if($statusA -eq $true)
            {
               #If user does exist, output a warning message
               Disable-ADAccount -server '192.168.21.2' -Identity $Username -Credential $mycreds
               get-aduser $username  -server 'nbt.lan' -Credential $mycreds |  Move-ADObject -server 'nbt.lan' -TargetPath "OU=Offboard,OU=NearbyTechnologies,DC=nbt,DC=lan" -Credential $mycreds

               Get-ADUser -Identity $Username -Server '192.168.21.2' -Properties MemberOf -Credential $mycreds |ForEach-Object {$_.MemberOf |Remove-ADGroupMember -Members $_.DistinguishedName -server '192.168.21.2' -Credential $mycreds -Confirm:$false }
               
               Add-Content -Path $logfile -Value "$logtime : suspended $Username"


 
            }
       }
      

    
      
       #Check if the user account already exists in AD
       if (Get-ADUser -server 'nbtdc.local' -F {SamAccountName -eq $Username})
       {
          $statusB = Get-ADUser -server 'nbtdc.local' -Filter 'SamAccountName -eq $Username' -Properties Enabled |Select-Object Enabled -ExpandProperty Enabled -ErrorAction SilentlyContinue
        
            if($statusB -eq $true)
            {
               #If user does exist, output a warning message
               Disable-ADAccount -server 'nbtdc.local' -Identity $Username
               get-aduser -Identity $Username | Move-ADObject -server 'nbtdc.local' -TargetPath "OU=Offboard,OU=Nearby_Technologies,DC=nbtdc,DC=local"

               Add-Content -Path $logfile -Value "$logtime : suspended $Username"
               #Send-GmailMessage -From helpdesk@paynearby.in -To noc.windows@locuz.com -CC infrateam@paynearby.in -Subject "NBTDC Offboard - User Diabled "  -BodyAsHtml -Body  "Hi team, `nBelow members are disabled in active directory.'nKindly disable all other access related to this user.`n#$Username - $mail"

 
            }
       }
              
      
    If($mail -ne $null)
        {
        
       $gsuituser = Get-GSUser -Filter *| Where-Object {($_.User -eq $mail) -and ($_.Suspended -eq $false) -and ($_.OrgUnitPath -ne '/Offboard')} | Select-Object User -ExpandProperty User -ErrorAction SilentlyContinue
      
    if($gsuituser -eq $mail)
        {

           Invoke-GSUserOffboarding -User $mail -Confirm:$false -Options Full -DestinationOrgUnit '/Offboard'

           Start-Sleep -s 30

           $usergs= Get-GSGroup -Where_IsAMember "$mail" |select email -ExpandProperty email

           if ($usergs -ne $null)
            {
                foreach ($userg in $usergs)
                {
                    Remove-GSGroupMember -Identity $userg -Member $mail -Confirm:$false
                }
            }



           $emailstatus=  Get-GSUser -User $mail |select Suspended -ExpandProperty Suspended

           Add-Content -Path $logfile -Value "$logtime : suspended $mail"
           Send-GmailMessage -From helpdesk@paynearby.in -To infrateam@paynearby.in -CC $recruiter -Subject "HROne Offboard automation"  -BodyAsHtml -Body  "Hi team, `nBelow members are disabled in gsuite and active directory`n#$Username - $mail `n$asset"


              $hash = [ordered] @{
                        EMPLOYEE_CODE =	$User.'employee code'
                        FIRST_NAME	= $User.'first name'
                        MIDDLE_NAME	= $User.'middle name'
                        LAST_NAME = $User.'last name'
                        LOCATION =	$User.branch
                        DOB = $User.'date of birth'
                        DOR = $User.'date of Resignation'
                        LWD = $User.'date of Leaving'
                        MOBILE = $User.'mobile number'	
                        DESIGNATION = $User.designation
                        Department = $User.department
                        REPORTING_MANAGER =	$User.'reproting manager name'
                        REPORTING_MANAGER_EMAIL_ID = $User.'reproting manager email'
                        WORK_EMAIL = $User.'work email'
                        Email_ID_Disabled =	$emailstatus
                        AD_Disabled = "Disabled"
                        Action_DATE = $today
                        DONE_BY	= 'Krishna'
                        }

         $sheetdata = New-Object PSObject -Property $hash
                     
         Add-GSSheetValues -SpreadsheetId $sheetId -SheetName $sheetname -Array $sheetdata  -Append


        }
        }
            
#           Send-GmailMessage -From helpdesk@paynearby.in -To infrateam@paynearby.in -Subject "HROne Offboard automation"  -BodyAsHtml -Body  "Hi team, <br> Offboard details of #$Username - $mail <br>Pending asset shown below( if any): <br>$asset"


}

}