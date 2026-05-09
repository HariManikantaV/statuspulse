#!/bin/bash
LOG_FILE="/var/log/statuspulse-monitor.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Check App Health
if curl -sk https://statuspulse.local/health | grep -q "healthy"; then
    STATE="HEALTHY"
else
    STATE="CRITICAL"
fi

echo "[$TIMESTAMP] StatusPulse App: $STATE - Routine check complete." >> "$LOG_FILE"