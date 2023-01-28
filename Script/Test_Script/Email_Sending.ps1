#################################################################################################
# $EmailTo = "akash.d@paynearby.in" 
# $EmailFrom = "akash.d@paynearby.in" 
# $EmailPW = $EmailPassword
# $Subject = "Test" 
# $Body = "Test" 
# $Attachment = New-Object System.Net.Mail.Attachment($attachmentpath)
# $SMTPServer = "192.168.21.164" 
# $SMTPPort = 25
# $SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
# $attachment = New-Object System.Net.Mail.Attachment($attachmentpath, 'text/plain')
# $SMTPMessage.Attachments.Add($attachment)
# $SMTPMessage.IsBodyHTML = $true 
# $SMTPMessage.Body = "<head><pre>$style</pre></head>" 
# $SMTPMessage.Body += Get-Content $diskReport 
# $SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer, $SMTPPort)  
# $SMTPClient.EnableSsl = $false 
# $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($EmailFrom, $EmailPW);  
# $SMTPClient.Send($SMTPMessage) 

#################################################################################################


$From = "akash.d@paynearby.in"
$To = "akash.d@paynearby.in"
$Subject = "Test Mail"
$Body = "Test - Script"
$SMTPServer = "smtp.gmail.com"
$Cred = (Get-Credential -Credential $From)
$Port = 587

Send-MailMessage -To $To -From $From -Subject $Subject -Body $Body -SmtpServer $SMTPServer -Credential $Cred -UseSsl -Port $Port







