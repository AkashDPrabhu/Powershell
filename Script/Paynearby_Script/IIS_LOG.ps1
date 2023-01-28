
[CmdletBinding()]
Param (
 [Parameter(Position = 0, Mandatory = $False)]
 [Int] $Days = 1
)


Function Write-Log {
 [CmdletBinding()]
 Param ([String] $Type, [String] $Message)

 # Create a log file in the same location as the script containing all the actions taken
 $Logfile = $PSScriptRoot + "\log\Delete-IISlogs_Log_$(Get-Date -f 'yyyyMMdd').txt"
 If (!(Test-Path $Logfile)) {New-Item $Logfile -Force -ItemType File | Out-Null}

 $timeStamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
 "$timeStamp $Type $Message" | Out-File -FilePath $Logfile -Append
 
 Write-Verbose $Message
}

$username = “superadmin@nbtdc.local”
$password1 = ConvertTo-SecureString "IT@admin2k18" -AsPlainText -Force
#$password1 = ConvertTo-SecureString -string $ADencrpt 
$ad = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password1)


#################################################################
# Script Start
#################################################################

[Array] $excServers= Invoke-Command 	-ComputerName 192.168.21.123 -ScriptBlock {get-adcomputer -filter * -properties IPv4Address | select IPv4Address -expandproperty IPv4Address | Sort-Object "IPv4Address"} -Credential $ad

ForEach ($server in $excServers) {
 Write-Log -Type "INF" -Message "Processing $server"
  Try {
   $countDel = Invoke-Command -ComputerName $server -ArgumentList $Days, $server -credential $ad -ScriptBlock {
    param($Days, $server)
    
    [Int] $countDel = 0
    Import-Module WebAdministration
    ForEach($webSite in $(Get-WebSite)) {
        $dir = "$($webSite.logFile.directory)\W3SVC$($webSite.ID)".Replace("%SystemDrive%", $env:SystemDrive)
     
     Write-Host "Checking IIS logs in $dir on $server" -ForegroundColor Green
     Get-ChildItem -Path $dir -Recurse | ? {$_.LastWriteTime -lt (Get-Date).addDays(-$Days)} | ForEach {
      Write-Host "Deleting", $_.FullName
      del $_.FullName -Confirm:$False
      $countDel++
     }
    }
    
    Return $countDel
   }
   
   Write-Log -Type "INF" -Message "Deleted $countDel logs from server $server"
  } Catch {
   Write-Log -Type "ERR" -Message "Unable to connect to $($server): $($_.Exception.Message)"
     }
 } Else {
  Write-Log -Type "ERR" -Message "Unable to connect to $server"
  }

