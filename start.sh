#!/bin/bash

# Ejecutar backup en el primer arranque si RUN_ON_STARTUP está activado
if [ "$RUN_ON_STARTUP" = "true" ]; then
    echo "[$(date)] Ejecutando backup inicial..."
    /backup.sh
fi

# Configurar crontab dinámicamente
echo "$CRON_SCHEDULE /backup.sh >> /var/log/backup.log 2>&1" > /etc/crontabs/root

echo "[$(date)] Tarea programada: '$CRON_SCHEDULE' para ejecutar /backup.sh"

# Iniciar cron en segundo plano
crond -f -d 8
