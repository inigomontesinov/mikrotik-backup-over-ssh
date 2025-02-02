# Use a lightweight base image
FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache openssh-client curl bash coreutils findutils

# Environment variables (customizable in docker run)
ENV MIKROTIK_IP="192.168.88.1"
ENV MIKROTIK_USER="admin"
# Default execution at midnight
ENV CRON_SCHEDULE="0 0 * * *"
# How many backups to keep before deleting
ENV BACKUP_ROTATION=7
# Run backup on container startup
ENV RUN_ON_STARTUP=true

# Copy files to the container
COPY backup.sh /backup.sh
COPY start.sh /start.sh

# Grant execution permissions
RUN chmod +x /backup.sh /start.sh \
    && ln -sf /dev/stdout /var/log/backup.log

# Execute the startup script (sets up cron and launches the process)
CMD ["/start.sh"]
