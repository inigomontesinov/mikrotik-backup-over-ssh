#!/bin/bash

# Configuration
MIKROTIK_IP=${MIKROTIK_IP:-"192.168.88.1"}
MIKROTIK_USER=${MIKROTIK_USER:-"admin"}
BACKUP_ROTATION=${BACKUP_ROTATION:-7}  # How many backups to keep

# Directory where backups are stored in the container
BACKUP_DIR="/backups"
DATE=$(date +"%Y%m%d_%H%M%S")

mkdir -p "$BACKUP_DIR"
mkdir -p /tmp/"$DATE"

# Backup name
BACKUP_NAME="backup_${DATE}"

echo "[$(date)] Connecting to MikroTik and creating backup..."

# Connect via SSH and execute backup commands
ssh -i "$MIKROTIK_SSH_KEY" -o StrictHostKeyChecking=no "$MIKROTIK_USER@$MIKROTIK_IP" \
    "/system backup save name=$BACKUP_NAME.backup; /export file=$BACKUP_NAME.rsc" > /dev/null 2>&1

echo "[$(date)] Downloading backup..."

# Download the backup files from MikroTik to the container
scp -i "$MIKROTIK_SSH_KEY" -o StrictHostKeyChecking=no "$MIKROTIK_USER@$MIKROTIK_IP:/$BACKUP_NAME.backup" /tmp/"$DATE"/ > /dev/null 2>&1
scp -i "$MIKROTIK_SSH_KEY" -o StrictHostKeyChecking=no "$MIKROTIK_USER@$MIKROTIK_IP:/$BACKUP_NAME.rsc" /tmp/"$DATE"/ > /dev/null 2>&1

echo "[$(date)] Compressing backup..."

tar -cf ${BACKUP_NAME}.tar /tmp/"$DATE"/ > /dev/null 2>&1
rm -rf /tmp/"$DATE"/
gzip ${BACKUP_NAME}.tar

mv ${BACKUP_NAME}.tar.gz "$BACKUP_DIR"/.

echo "[$(date)] Backup saved in: "$BACKUP_DIR"/${BACKUP_NAME}.tar.gz"

# Backup rotation: Keep only the last N backups
echo "[$(date)] Applying backup rotation (keeping the last $BACKUP_ROTATION)..."
ls -tp "$BACKUP_DIR" | grep -v '/$' | tail -n +$((BACKUP_ROTATION + 1)) | xargs -I {} rm -- "$BACKUP_DIR/{}"

echo "[$(date)] Backup rotation completed."
