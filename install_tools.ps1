<powershell>
 
Write-Output "Installing Chocolatey"
 
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = 3072
 
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
 
choco install git -y
choco install vscode -y
 
New-Item C:\DevToolsInstalled.txt
 
</powershell>
 
