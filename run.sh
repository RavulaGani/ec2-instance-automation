#!/bin/bash
 
# AMI IDs (change if needed for your region)
LINUX_AMI="ami-0df4b2961410d4cff"
WINDOWS_AMI="ami-00802439f7dc66eab"
 
INSTANCE_TYPE="t3.micro"
KEY_NAME="my-keypair"
SECURITY_GROUP="default"
 
echo "Launching Linux Web Server..."
 
aws ec2 run-instances \
--image-id $LINUX_AMI \
--instance-type $INSTANCE_TYPE \
--key-name $KEY_NAME \
--security-groups $SECURITY_GROUP \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Linux-Web-Server}]' \
--user-data file://linux-setup.sh
 
 
echo "Launching Linux Docker Server..."
 
aws ec2 run-instances \
--image-id $LINUX_AMI \
--instance-type $INSTANCE_TYPE \
--key-name $KEY_NAME \
--security-groups $SECURITY_GROUP \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Linux-Docker-Server}]' \
--user-data file://install_docker.sh
 
 
echo "Launching Linux Monitoring Server..."
 
aws ec2 run-instances \
--image-id $LINUX_AMI \
--instance-type $INSTANCE_TYPE \
--key-name $KEY_NAME \
--security-groups $SECURITY_GROUP \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Linux-Monitoring-Server}]' \
--user-data file://monitor.sh
 
 
echo "Launching Windows Web Server..."
 
aws ec2 run-instances \
--image-id $WINDOWS_AMI \
--instance-type $INSTANCE_TYPE \
--key-name $KEY_NAME \
--security-groups $SECURITY_GROUP \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Windows-Web-Server}]' \
--user-data file://windows-setup.ps1
 
 
echo "Launching Windows Dev Server..."
 
aws ec2 run-instances \
--image-id $WINDOWS_AMI \
--instance-type $INSTANCE_TYPE \
--key-name $KEY_NAME \
--security-groups $SECURITY_GROUP \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Windows-Dev-Server}]' \
--user-data file://install_tools.ps1
 
 
echo "Infrastructure deployment completed!"
