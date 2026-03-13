#!/bin/bash
 
LINUX_AMI="ami-018bef78e20688ef5"
WINDOWS_AMI="ami-02cbacf922dcb7280"
 
INSTANCE_TYPE="t3.micro"
KEY_NAME="my-keypair"
 
echo "Launching Linux Web Server..."
aws ec2 run-instances \
--image-id $LINUX_AMI \
--instance-type $INSTANCE_TYPE \
--key-name $KEY_NAME \
--user-data file://linux-setup.sh
 
echo "Launching Linux Docker Server..."
aws ec2 run-instances \
--image-id $LINUX_AMI \
--instance-type $INSTANCE_TYPE \
--key-name $KEY_NAME \
--user-data file://install_docker.sh
 
echo "Launching Linux Monitoring Server..."
aws ec2 run-instances \
--image-id $LINUX_AMI \
--instance-type $INSTANCE_TYPE \
--key-name $KEY_NAME \
--user-data file://monitor.sh
 
echo "Launching Windows Web Server..."
aws ec2 run-instances \
--image-id $WINDOWS_AMI \
--instance-type $INSTANCE_TYPE \
--key-name $KEY_NAME \
--user-data file://windows-setup.ps1
 
echo "Launching Windows Dev Server..."
aws ec2 run-instances \
--image-id $WINDOWS_AMI \
--instance-type $INSTANCE_TYPE \
--key-name $KEY_NAME \
--user-data file://install_tools.ps1
 
echo "Infrastructure deployment completed"
