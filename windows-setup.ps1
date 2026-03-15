<powershell>
 
Install-WindowsFeature -Name Web-Server
 
$html = @"
<!DOCTYPE html>
<html>
<head>
<title>AWS EC2 Automation Project</title>
 
<style>
body{
    font-family: Arial;
    background: linear-gradient(135deg,#1e3c72,#2a5298);
    color:white;
    text-align:center;
    padding-top:100px;
}
 
.container{
    background:white;
    color:#333;
    width:60%;
    margin:auto;
    padding:40px;
    border-radius:10px;
    box-shadow:0px 10px 25px rgba(0,0,0,0.3);
}
 
h1{
    color:#2a5298;
}
 
.server{
    margin-top:20px;
    padding:15px;
    background:#f4f6f9;
    border-radius:6px;
}
 
.footer{
    margin-top:20px;
    font-size:14px;
    color:#666;
}
</style>
 
</head>
 
<body>
 
<div class="container">
 
<h1>AWS EC2 Infrastructure Automation</h1>
 
<p>This Windows server was deployed automatically using <b>AWS CLI + PowerShell</b>.</p>
 
<div class="server">
<h3>Server Information</h3>
<p>Operating System: Windows Server</p>
<p>Web Server: IIS</p>
<p>Deployment: Automated Script</p>
</div>
 
<div class="server">
<h3>Infrastructure Components</h3>
<p>Linux Web Server (Nginx)</p>
<p>Linux Docker Server</p>
<p>Linux Monitoring Server</p>
<p>Windows Web Server (IIS)</p>
<p>Windows Dev Server</p>
</div>
 
<div class="footer">
<p>DevOps Automation Project</p>
<p>Created by <b>Ravula Ganesh</b></p>
</div>
 
</div>
 
</body>
</html>
"@
 
$html | Out-File "C:\inetpub\wwwroot\index.html"
 
</powershell>
