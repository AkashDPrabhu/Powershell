$today = (Get-Date).ToString("yyyy-MM-dd")
$lastweek = ((Get-Date).AddDays(-7)).ToString("yyyy-MM-dd")

$logfile = "D:\HROne\HRONE_ONBOARD.csv"
$logtime = Get-Date

$sheetId= "1CgipYjzHnb7GHhfMoIO7Xsqig0mo_msmDvYaSdPTJTw"
$sheetname="Onboard" 

$secpasswd = "01000000d08c9ddf0115d1118c7a00c04fc297eb0100000079372d9422e9d44e85d3040a3007c8ba0000000002000000000003660000c000000010000000124a735ebee711c96252a4d226e5c8080000000004800000a000000010000000b50fda0898da1dd4b49a16127e8538f110000000a51075aa46f9df2885e20585c538b650140000000902507ac7353e9ac07c12662387dcaf60c6917d" |Convertto-SecureString -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("appadmin@nbt.lan", $secpasswd)


$recruiter = "sameer.virkud@paynearby.in", "akshay.rai@paynearby.in", "brijesh.kumar@paynearby.in", "vivekkumar.mishra@paynearby.in", "kathiravan.m@paynearby.in", "ramesh.thapa@paynearby.in"

if (!(Test-Path $logfile))
{
   New-Item -path $logfile
}

Add-Type -AssemblyName System.Web

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
"fromCreatedDate" :  "$lastweek",
"toCreatedDate" : "$today",
"pagination":
	{
"pageNumber": 1,
"pageSize": 10000
}
}
"@


$users = Invoke-RestMethod -Body $Body -Headers $header -Uri $apiUrl -Method Post | select -ExpandProperty *


If($users -ne $null)
{
foreach ($User in $users)
{

       $Username    = $User.'employee code'
       $Firstname   = $User.'first name'
       $Middlename  = $User.'middle name'
       $Lastname    = $User.'last name'
       $name        =  "$Firstname $Middlename $Lastname "
       $Department  = $User.department
       $OU          = "OU=Automation,OU=NearbyTechnologies,DC=nbt,DC=lan"
       $designation =$User.designation 
       $subdepartment=$User.'sub department'
       $branch      = $User.branch
       $subbranch   =$User.'sub branch'
       $description = "$designation - $subdepartment - $branch - $subbranch"
       $mail = $User.'work email'
       $mobile =$User.'mobile number'
       $managermail = $User.'reproting manager email'
       $managerid =$user.'reporting manager code' 
       $emaildomain= $mail.Split("@")[1]
       $gsuituser = Get-GSUser -Filter *  | Where-Object { ($_.User -eq $mail) -and ($_.Suspended -eq $false)} | Select-Object User -ExpandProperty User 
       $random = [System.Web.Security.Membership]::GeneratePassword(12,2)
       $password = ConvertTo-SecureString -String $random -AsPlainText -Force



if(!(Test-NetConnection -ComputerName 192.168.21.2 -Port 389 -InformationLevel Quiet))
{
       Send-GmailMessage -From helpdesk@paynearby.in -To infrateam@paynearby.in -Subject "HROne-IT Onboarding | Failed" -Body "Failed to connect NBT.LAN - 192.168.21.2"
}


if(!(Get-GSuser ))
{
       Send-GmailMessage -From helpdesk@paynearby.in -To infrateam@paynearby.in -Subject "HROne-IT Onboarding | Failed" -Body "Failed to connect to Gsuite API"
}
else
{
        Write-Warning "Connected to Gsuite API"
                         

       #Check if the user account already exists in AD
       if (Get-ADUser -server '192.168.21.2' -Credential $mycreds -F {SamAccountName -eq $Username})
       {
               #If user does exist, output a warning message
               Write-Warning "A user account $Username has already exist in Active Directory."
       }
       else
       {
              #If a user does not exist then create a new user account
          
              New-ADUser -Server '192.168.21.2' -SamAccountName $Username -UserPrincipalName "$Username@nbt.lan" -Name $name -GivenName $Firstname -Surname $Lastname -Enabled $False -ChangePasswordAtLogon $True -DisplayName $name -Department $Department -Path $OU -EmailAddress $mail -AccountPassword $password -Description $description -HomeDirectory "\\192.168.11.102\home\$Username" -HomeDrive H: -mobile $mobile -EmployeeID $Username -Credential $mycreds
              Write-Warning "A user account $Username created in Active Directory."
              Add-Content -Path $logfile -Value "$logtime : created $Username"
         
       

    if ($emaildomain -eq "paynearby.in")
    {
    if ($gsuituser -ne $mail)
        {

                $org = Add-GSUserOrganization -Department $Department -Title "$Username- $designation" -Type work 
        
                $extId = Add-GSUserExternalId -Type organization -Value $Username
        
                $phone = Add-GSUserPhone -Type Work -Value "$mobile" -Primary

                $relations = Add-GSUserRelation -Type manager -Value $managermail


                New-GSUser -PrimaryEmail $mail -GivenName $Firstname -FamilyName $Lastname -Password $password -ChangePasswordAtNextLogin -IncludeInGlobalAddressList -Phones $phone -Organizations $org  -ExternalIds $extId -Relations $relations -OrgUnitPath '/2step verification enforce'
        
                Start-Sleep -s 30

                $newmail = Get-GSUser -Filter *  | Where-Object { ($_.User -eq $mail) -and ($_.Suspended -eq $false)} | Select-Object User -ExpandProperty User 
                
                
                if(($Department -ne 'Retail Sales') -and ($branch -eq 'Chennai HO'))
                {
                  Add-GSGroupMember "chennai@paynearby.in" -Member $newmail
                }

                if(($Department -ne 'Retail Sales') -and ($branch -ne 'Chennai HO'))
                {
                  Add-GSGroupMember "mumbai@paynearby.in" -Member $newmail
                }

        

                    if($newmail -eq $mail)

                    {
                        Send-GmailMessage -From helpdesk@paynearby.in -To infrateam@paynearby.in -Subject "HROne-IT Onboard Joiner Detaild #$username | Success" -Body  "Hi team, `nBelow member is created in gsuite and active directory `n$username - $mail `nOTP sent to Manager Mail: $managermail `nOTP is $random" 
       
                        Send-GmailMessage -From helpdesk@paynearby.in -To $recruiter -Subject "HROne-IT Onboard Joiner Detaild #$username | Success" -Body  "Hi team, `nBelow member is created in gsuite and active directory `n$username - $mail `nPassword sent to Manager Mail: $managermail `nPassword is $random" 

                        Send-GmailMessage -From helpdesk@paynearby.in -To $managermail -Subject "HROne -ITOnboard Joiner Detaild #$username" -Body  "Hi team, `nBelow member is created in gsuite and active directory `n$username - $mail `nPassword is $random" 
        
                        Add-Content -Path $logfile -Value "$logtime : created $mail"
       
        $hash = [ordered] @{
                        EMPLOYEE_CODE =	$User.'employee code'
                        FIRST_NAME	= $User.'first name'
                        MIDDLE_NAME	= $User.'middle name'
                        LAST_NAME = $User.'last name'
                        PERSONAL_EMAIL =$User.'personal email'
                        LOCATION =	$User.branch
                        DOB = $User.'date of birth'
                        DOJ = $User.'date of Joining'
                        MOBILE = $User.'mobile number'	
                        GRADE = $User.'grade'
                        PAN_NUMBER = $User.'pan no.'	
                        AADHAAR_NUMBER = $User.'aadhar no.'
                        DESIGNATION = $User.designation
                        Department = $User.department
                        REPORTING_MANAGER =	$User.'reproting manager name'
                        REPORTING_MANAGER_EMAIL_ID = $User.'reproting manager email'
                        ADDRESS = $User.'permanent Address'
                        STATE =$User.'permanent state'
                        District = $User.'permanent city'
                        PINCODE = $User.'current pin'
                        FATHERS_NAME =	$User.'father name'
                        WORK_EMAIL = $User.'work email'
                        Email_ID_creation =	'Created'
                        AD_creation =	'Created'
                        Password_shared = 'Sent'
                        CREATED_DATE = $User.'created date'
                        DONE_BY	= 'Krishna'
                        }

         $sheetdata = New-Object PSObject -Property $hash            
         Add-GSSheetValues -SpreadsheetId $sheetId -SheetName $sheetname -Array $sheetdata  -Append

                
                    }
       
                   else
                    {
                        Send-GmailMessage -From helpdesk@paynearby.in -To infrateam@paynearby.in -Subject "HROne-IT Onboard Joiner Detaild #$username | Failed" -Body  "Hi team, `nError While creating mail `n$username - $mail `nPlease check and clear `n-IT Team" 
        
                        Send-GmailMessage -From helpdesk@paynearby.in -To $recruiter -Subject "HROne-IT Onboard Joiner Detaild #$username | Failed" -Body  "Hi team, `nError While creating mail `n$username - $mail `nPlease check and clear `n-IT Team" 
                    }
       
            }
       else
       {
                       Send-GmailMessage -From helpdesk@paynearby.in -To infrateam@paynearby.in -Subject "HROne-IT Onboard Joiner Detaild #$username | Failed" -Body  "Hi team, `nError While creating mail `n$username - $mail `nReason: Mail ID Already Exists" 
        
                       Send-GmailMessage -From helpdesk@paynearby.in -To $recruiter -Subject "HROne-IT Onboard Joiner Detaild #$username | Failed" -Body  "Hi team, `nError While creating mail `n$username - $mail `nReason: Mail ID Already Exists" 
        
       }

    }

       else
       {
                        Send-GmailMessage -From helpdesk@paynearby.in -To infrateam@paynearby.in -Subject "HROne-IT Onboard Joiner Detaild #$username | Failed" -Body  "Hi team, `nError While creating mail `n$username - $mail `nReason: Mail ID Domain is not paynearby.in" 
        
                        Send-GmailMessage -From helpdesk@paynearby.in -To $recruiter -Subject "HROne-IT Onboard Joiner Detaild #$username | Failed" -Body  "Hi team, `nError While creating mail `n$username - $mail `nReason: Mail ID Domain is not paynearby.in" 
                       
                      
       }


}
   
   

}
}
}