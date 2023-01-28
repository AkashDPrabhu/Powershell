$username = "superadmin@nbt.lan"
$password1 = ConvertTo-SecureString "netAdmin@123" -AsPlainText -Force
$ad = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password1)

$event = Get-EventLog -ComputerName CHNADC01.nbt.lan -LogName Security -source Microsoft-Windows-Security-Auditing -newest 1


#get-help get-eventlog will show there are a handful of other options available for selecting the log entry you want.
if ($event.EntryType -eq "Success")
{
    $PCName = $env:COMPUTERNAME
    $EmailBody = $event.Message
    $EmailFrom = "akash.d@paynearby.in"
    $EmailTo = "chandru.s@paynearby.in" 
    $EmailSubject = "User was created!"
    $SMTPServer = "smtp.gmail.com"
    $Cred = (Get-Credential -Credential $From)
    $Port = 587
    Write-host "Sending Email"
    Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -body $EmailBody -SmtpServer $SMTPServer -Credential $Cred -UseSsl -Port $Port
}
else
{
    write-host "No records found"
}