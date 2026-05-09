#!/bin/bash
BACKUP_DIR="/home/ubuntu/statuspulse/backups"
TIMESTAMP=$(date "+%Y-%m-%d_%H%M%S")
FILENAME="statuspulse_db_${TIMESTAMP}.sql.gz"

mkdir -p "$BACKUP_DIR"

# Export database from the running container
docker exec statuspulse-db-1 pg_dumpall -U postgres | gzip > "$BACKUP_DIR/$FILENAME"

# Rotation: Keep only the 7 most recent files
cd "$BACKUP_DIR" && ls -tp | grep -v '/$' | tail -n +8 | xargs -I {} rm -- {}

echo "[$TIMESTAMP] Backup created: $FILENAME" >> /var/log/statuspulse-monitor.log