#!/bin/bash
 
LOGFILE="/home/ubuntu/system-monitor.log"
 
echo "Monitoring started at $(date)" >> $LOGFILE
 
top -b -n1 >> $LOGFILE
df -h >> $LOGFILE
free -m >> $LOGFILE
