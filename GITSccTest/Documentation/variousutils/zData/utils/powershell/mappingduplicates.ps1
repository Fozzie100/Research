$ServerName = "LDNPCM05094V05B\PLN000000152L"
$DatabaseName = "BCARD_PROD"
$path = "C:\zData\utils\powershell"
$file = "mappingdupsquery.sql"
$outfile = "duplicates.txt"
$cmdPath = Join-Path $path $file

$outpath = Join-Path $path $outfile
# Write-Host "$CurrentDateTime executing script ""$cmdPath"" `r`nServer: ""$ServerName"" `r`nDatabase:""$DatabaseName""" -ForegroundColor Green -BackgroundColor Black ;

	sqlcmd.exe -S $ServerName -d $DatabaseName -i $cmdPath -o $outpath
    
    
$emailTo = "Philip.Pulling@barcap.com,Jakub.Kasprzak@barcap.com,Ian.x.Graham@barcap.com,Ferran.NoguerolesDOliveira@barcap.com"
$emailFrom = "Philip.Pulling@barcap.com" 
$subject="mappi.Mapping table duplicates - most recent top 10" 
$body = "Please find attached most recent duplicates file top 10 MaxCreateDate descending"
   $attachment = $outpath   
   $smtpPort = 25
   
   
 $message = New-Object System.Net.Mail.MailMessage
$message.subject = $subject
$message.body = $body
$message.to.add($emailTo)
#$message.cc.add($cc)
$message.from = $emailFrom
$message.attachments.add($attachment)

$smtpserver="mailhost" 
$smtp=new-object Net.Mail.SmtpClient($smtpServer) 
$smtp.Port = $smtpPort

$smtp.send($message)


<#
 $message = "Testing multiple reciepients"        
 $smtpPort = 25
 $emailTo = "Philip.Pulling@barcap.com,Jakub.Kasprzak@barcap.com"
$emailFrom = "Philip.Pulling@barcap.com" 
$subject="mappi.Mapping table duplicates - most recent top 10" 
$smtpserver="mailhost" 
$smtp=new-object Net.Mail.SmtpClient($smtpServer) 
$smtp.Port = $smtpPort
$smtp.Send($emailFrom, $emailTo, $subject, $message) 
#>