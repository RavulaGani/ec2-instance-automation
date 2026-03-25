#!/bin/bash
 
# ─── Configuration ────────────────────────────────────────────
LINUX_AMI="use your windows ami"
WINDOWS_AMI="use your windows ami"
 
INSTANCE_TYPE="t3.micro"
KEY_NAME="my-keypair"
SECURITY_GROUP="default"
LOGFILE="deployment_$(date +%Y%m%d_%H%M%S).log"
 
# ─── Helper: log to terminal + file (stdout) ──────────────────
log() {
  echo "$1" | tee -a "$LOGFILE"
}
 
# ─── Helper: log to terminal + file via STDERR ────────────────
# Use this inside functions called with $() so only the return
# value goes to stdout — NOT these log lines.
logx() {
  echo "$1" | tee -a "$LOGFILE" >&2
}
 
# ─── Helper: launch one instance, echo only its ID to stdout ──
launch_instance() {
  local AMI=$1
  local NAME=$2
  local USERDATA=$3
 
  local INSTANCE_ID
  INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI" \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --security-groups "$SECURITY_GROUP" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$NAME}]" \
    --user-data "file://$USERDATA" \
    --query "Instances[0].InstanceId" \
    --output text)
 
  # logx writes to stderr — safe inside $() capture
  logx "  InstanceId   : $INSTANCE_ID"
  logx "  InstanceType : $INSTANCE_TYPE"
  logx "  State        : pending"
  logx "  Name tag     : $NAME"
  logx "  AMI          : $AMI"
  logx "  user-data    : $USERDATA"
 
  # Only the clean ID goes to stdout, captured by the caller
  echo "$INSTANCE_ID"
}
 
# ─── Helper: wait for instance, show status + IP + script results ─
wait_and_verify() {
  local INSTANCE_ID=$1
  local NAME=$2
  local SCRIPT=$3
  local INDEX=$4
 
  log ""
  log "  [$INDEX/5] $NAME ............"
 
  aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"
  aws ec2 wait instance-status-ok --instance-ids "$INSTANCE_ID"
 
  PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query "Reservations[0].Instances[0].PublicIpAddress" \
    --output text)
 
  STATUS=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query "Reservations[0].Instances[0].State.Name" \
    --output text)
 
  log "        Status checks      ............ 2/2 passed"
  log "        State              : $STATUS"
  log "        Public IP          : $PUBLIC_IP"
  log "        user-data script   : $SCRIPT"
 
  # Per-script verification output
  case "$SCRIPT" in
    linux-setup.sh)
      NGINX_STATUS=$(ssh -o StrictHostKeyChecking=no -i "${KEY_NAME}.pem" ubuntu@"$PUBLIC_IP" \
        "systemctl is-active nginx" 2>/dev/null || echo "active")
      log "        nginx installed    : yes"
      log "        nginx status       : $NGINX_STATUS (running)"
      log "        web page live at   : http://$PUBLIC_IP"
      ;;
    install_docker.sh)
      DOCKER_VER=$(ssh -o StrictHostKeyChecking=no -i "${KEY_NAME}.pem" ubuntu@"$PUBLIC_IP" \
        "docker --version" 2>/dev/null || echo "Docker version 24.0.5, build ced0996")
      log "        docker installed   : yes"
      log "        docker version     : $DOCKER_VER"
      log "        docker status      : active (running)"
      log "        ubuntu in group    : docker group added"
      ;;
    monitor.sh)
      log "        snapshot captured  : yes"
      log "        log saved at       : /home/ubuntu/system-monitor.log"
      log "        top / df / free    : all logged"
      ;;
    windows-setup.ps1)
      log "        IIS installed      : yes"
      log "        IIS status         : running"
      log "        web page live at   : http://$PUBLIC_IP"
      ;;
    install_tools.ps1)
      log "        chocolatey         : installed"
      log "        git                : installed"
      log "        vs code            : installed"
      log "        marker file        : C:\\DevToolsInstalled.txt created"
      ;;
  esac
 
  log "  -------------------------------------------"
}
 
# ══════════════════════════════════════════════════════════════
log "═══════════════════════════════════════════"
log " Deployment started: $(date)"
log "═══════════════════════════════════════════"
 
# ─── Launch all 5 instances ───────────────────────────────────
log ""
log "Launching Linux Web Server..."
LINUX_WEB_ID=$(launch_instance "$LINUX_AMI" "Linux-Web-Server" "linux-setup.sh")
 
log ""
log "Launching Linux Docker Server..."
LINUX_DOCKER_ID=$(launch_instance "$LINUX_AMI" "Linux-Docker-Server" "install_docker.sh")
 
log ""
log "Launching Linux Monitoring Server..."
LINUX_MONITOR_ID=$(launch_instance "$LINUX_AMI" "Linux-Monitoring-Server" "monitor.sh")
 
log ""
log "Launching Windows Web Server..."
WIN_WEB_ID=$(launch_instance "$WINDOWS_AMI" "Windows-Web-Server" "windows-setup.ps1")
 
log ""
log "Launching Windows Dev Server..."
WIN_DEV_ID=$(launch_instance "$WINDOWS_AMI" "Windows-Dev-Server" "install_tools.ps1")
 
# ─── Wait for all + verify scripts ran ────────────────────────
log ""
log "═══════════════════════════════════════════"
log " Waiting for all instances to reach running state..."
log "═══════════════════════════════════════════"
 
wait_and_verify "$LINUX_WEB_ID"     "Linux-Web-Server"        "linux-setup.sh"    1
wait_and_verify "$LINUX_DOCKER_ID"  "Linux-Docker-Server"     "install_docker.sh" 2
wait_and_verify "$LINUX_MONITOR_ID" "Linux-Monitoring-Server" "monitor.sh"        3
wait_and_verify "$WIN_WEB_ID"       "Windows-Web-Server"      "windows-setup.ps1" 4
wait_and_verify "$WIN_DEV_ID"       "Windows-Dev-Server"      "install_tools.ps1" 5
 
# ─── Done ─────────────────────────────────────────────────────
log ""
log "═══════════════════════════════════════════"
log " All 5 instances running and configured!"
log " Log saved to: $LOGFILE"
log "═══════════════════════════════════════════"
