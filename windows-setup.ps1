<powershell>
 
Install-WindowsFeature -Name Web-Server
 
$html = "<h1>Windows Server deployed using AWS CLI automation</h1>"
 
$html | Out-File "C:\inetpub\wwwroot\index.html"
 
</powershell>
