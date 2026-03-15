#!/bin/bash
 
sudo apt update -y
sudo apt install nginx git -y
 
sudo systemctl start nginx
sudo systemctl enable nginx
 
cd /var/www/html
 
sudo rm -rf *
 
sudo git clone https://github.com/RavulaGani/Portfolio.git .
 
sudo systemctl restart nginx
