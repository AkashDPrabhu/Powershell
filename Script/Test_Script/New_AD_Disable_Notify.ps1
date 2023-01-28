# $mailRecipients = "akash.d@paynearby.in"
# $mailSender = "akash.d@paynearby.in"
# $mailSubject = "AD USER SUSPEND NOTIFY"
# $mailServer = "smtp.gmail.com"
# $Cred = (Get-Credential -Credential $From)


$password = ConvertTo-SecureString -String "IT@admin2k17" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("Administrator@akash.lan", $password)

$disable = Get-ADUser -server '10.0.0.20' -Filter 'SamAccountName -eq "nbt001"' -Properties Enabled -Credential $mycreds | Select-Object Enabled

#Write-Host $disable

    if($disable -eq $false)
    {
        Write-Host "Suspended"
        # Send-MailMessage -To $mailRecipients -From $mailSender -Subject $mailSubject -SmtpServer $mailServer -Port 587
    }