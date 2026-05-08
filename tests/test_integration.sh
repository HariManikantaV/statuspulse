#!/bin/bash
set -e 

URL="http://localhost:8000"
# Create a unique name for this specific test run
UNIQUE_NAME="Service_$RANDOM"

echo "1. GET /health - Checking stack health..."
HEALTH=$(curl -s -f "$URL/health")
echo $HEALTH | grep -q '"status":"healthy"'
echo "PASS: Health is healthy"

echo "2. POST /services - Adding a new service ($UNIQUE_NAME)..."
curl -s -f -X POST "$URL/services" \
     -H "Content-Type: application/json" \
     -d "{\"name\": \"$UNIQUE_NAME\", \"url\": \"http://example.com\"}" | grep -q "\"name\":\"$UNIQUE_NAME\""
echo "PASS: Service created"

echo "3. POST /services - Testing Duplicate (409)..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$URL/services" \
     -H "Content-Type: application/json" \
     -d "{\"name\": \"$UNIQUE_NAME\", \"url\": \"http://example.com\"}")
if [ "$STATUS" -eq 409 ]; then echo "PASS: Duplicate caught (409)"; else echo "FAIL: Expected 409 but got $STATUS"; exit 1; fi

echo "4. GET /services - Listing services..."
curl -s -f "$URL/services" | grep -q "$UNIQUE_NAME"
echo "PASS: Service list verified"

echo "5. POST /incidents - Creating an incident..."
curl -s -f -X POST "$URL/incidents" \
     -H "Content-Type: application/json" \
     -d "{\"service_name\": \"$UNIQUE_NAME\", \"title\": \"API Latency\"}" | grep -q '"status":"investigating"'
echo "PASS: Incident created"

echo "6. GET /incidents - Verifying incident list..."
curl -s -f "$URL/incidents" | grep -q "API Latency"
echo "PASS: Incident list verified"

echo "ALL TESTS PASSED SUCCESSFULLY!"