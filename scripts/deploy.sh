#!/bin/bash
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "[$TIMESTAMP] Starting Deployment..."

# 1. Pull/Rebuild
docker compose build app

# 2. Update the container
docker compose up -d --no-deps app

# 3. Health Check (Using -k for self-signed SSL)
echo "Waiting for health check..."
sleep 10
if curl -fk https://statuspulse.local/health | grep -q "healthy"; then
    echo "[$TIMESTAMP] Deployment Successful!"
else
    echo "[$TIMESTAMP] HEALTH CHECK FAILED! Rolling back..."
    # Rollback: Force a restart of the containers to the previous state
    docker compose up -d --force-recreate
    exit 1
fi