# AWS EC2 Instance Automation

This project demonstrates automated infrastructure deployment using AWS CLI and scripting.  
A single automation script launches multiple EC2 instances and configures them automatically using Linux Bash scripts and Windows PowerShell scripts.

The system provisions five servers, each with a specific role such as web hosting, container runtime, monitoring, and development tools.

--------------------------------------------------

## Project Architecture

The main automation script launches multiple EC2 instances and executes setup scripts through user-data during instance initialization.

run.sh
│
├── Linux Web Server
│     └── linux-setup.sh
│          installs nginx
│          hosts HTML webpage
│
├── Linux Docker Server
│     └── install_docker.sh
│          installs Docker engine
│          configures docker group
│
├── Linux Monitoring Server
│     └── monitor.sh
│          collects CPU, disk, memory stats
│          logs system metrics
│
├── Windows Web Server
│     └── windows-setup.ps1
│          installs IIS
│          hosts webpage
│
└── Windows Dev Server
      └── install_tools.ps1
           installs developer tools
           chocolatey + git + vscode

--------------------------------------------------

## Infrastructure Details

Instances are created with the following configuration.

Instance Type: t3.micro  
Linux AMI: Ubuntu AMI  
Windows AMI: Windows Server AMI  
Security Group: default  
Key Pair: my-keypair

--------------------------------------------------

## Servers Created

### Linux Web Server
Purpose: Host a web page using Nginx.

Setup actions:
- Updates packages
- Installs Nginx
- Starts and enables the service
- Deploys a sample HTML page

Access:

http://<Linux-Web-Public-IP>

--------------------------------------------------

### Linux Docker Server
Purpose: Container runtime environment.

Setup actions:
- Installs Docker
- Starts Docker service
- Adds ubuntu user to docker group
- Stores Docker version output

Verification command:

docker --version

--------------------------------------------------

### Linux Monitoring Server
Purpose: System monitoring and logging.

Setup actions:
- Collects system information
- Logs CPU, disk, and memory usage

Log file location:

/home/ubuntu/system-monitor.log

View logs:

sudo cat /home/ubuntu/system-monitor.log

--------------------------------------------------

### Windows Web Server
Purpose: Host a webpage using IIS.

Setup actions:
- Installs IIS Web Server
- Creates HTML page

Access:

http://<Windows-Web-Public-IP>

--------------------------------------------------

### Windows Dev Server
Purpose: Development environment.

Setup actions:
- Installs Chocolatey
- Installs Git
- Installs Visual Studio Code

Creates marker file:

C:\DevToolsInstalled.txt

--------------------------------------------------

## Project Files

ec2-instance-automation
│
├── run.sh
├── linux-setup.sh
├── install_docker.sh
├── monitor.sh
├── windows-setup.ps1
├── install_tools.ps1
└── README.md

--------------------------------------------------

## Prerequisites

Before running the project ensure the following:

- AWS CLI installed
- AWS account configured
- IAM permissions for EC2
- Key pair created
- Security group configured

Configure AWS CLI:

aws configure

Provide:

AWS Access Key  
AWS Secret Key  
Region  
Output format

--------------------------------------------------

## How to Execute

Step 1: Clone the repository

git clone https://github.com/RavulaGani/ec2-instance-automation.git

Step 2: Navigate to the project folder

cd ec2-instance-automation

Step 3: Give execution permission

chmod +x run.sh

Step 4: Run the automation script

./run.sh

--------------------------------------------------

## What Happens When Script Runs

1. AWS CLI launches EC2 instances
2. Instances start initializing
3. User-data scripts execute automatically
4. Services like Nginx, Docker, and IIS are installed
5. Monitoring logs are generated
6. Instance details and IP addresses are displayed

--------------------------------------------------

## Example Output

Launching Linux Web Server  
Launching Linux Docker Server  
Launching Linux Monitoring Server  
Launching Windows Web Server  
Launching Windows Dev Server  

Waiting for all instances to reach running state  

All 5 instances running and configured

--------------------------------------------------

## Deployment Logs

Deployment logs are saved automatically:

deployment_YYYYMMDD_HHMMSS.log

--------------------------------------------------

## Stop Instances

To stop instances manually:

aws ec2 stop-instances --instance-ids <instance-id>

--------------------------------------------------

## Security Notes

Do NOT upload sensitive files to GitHub.

Add .gitignore:

*.pem  
*.log

--------------------------------------------------

## Technologies Used

AWS EC2  
AWS CLI  
Bash scripting  
PowerShell scripting  
Nginx  
Docker  
IIS  
Chocolatey  
Git

--------------------------------------------------

## Learning Outcomes

This project demonstrates:

- Infrastructure automation
- Cloud resource provisioning
- Linux server configuration
- Windows server automation
- DevOps scripting
- Multi-platform deployments

--------------------------------------------------

## Author

Ravula Ganesh
