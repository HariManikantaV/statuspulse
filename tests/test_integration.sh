#!/bin/bash
set -e  # Exit on failure [cite: 230]

URL="http://localhost:8000"

echo "1. GET /health - Checking stack health..."
HEALTH=$(curl -s -f "$URL/health")
echo $HEALTH | grep -q '"status":"healthy"'
echo "PASS: Health is healthy [cite: 227, 231]"

echo "2. POST /services - Adding a new service..."
# Test 201 Created [cite: 228]
curl -s -f -X POST "$URL/services" \
     -H "Content-Type: application/json" \
     -d '{"name": "App-Service", "url": "http://example.com"}' | grep -q '"name":"App-Service"'
echo "PASS: Service created [cite: 231]"

echo "3. POST /services - Testing Duplicate (409)..."
# Verify 409 status code [cite: 228]
STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$URL/services" \
     -H "Content-Type: application/json" \
     -d '{"name": "App-Service", "url": "http://example.com"}')
if [ "$STATUS" -eq 409 ]; then echo "PASS: Duplicate caught (409) [cite: 228, 231]"; else exit 1; fi

echo "4. GET /services - Listing services..."
curl -s -f "$URL/services" | grep -q "App-Service"
echo "PASS: Service list verified [cite: 227]"

echo "5. POST /incidents - Creating an incident..."
curl -s -f -X POST "$URL/incidents" \
     -H "Content-Type: application/json" \
     -d '{"service_name": "App-Service", "title": "API Latency"}' | grep -q '"status":"investigating"'
echo "PASS: Incident created [cite: 227]"

echo "6. GET /incidents - Verifying incident list..."
curl -s -f "$URL/incidents" | grep -q "API Latency"
echo "PASS: Incident list verified [cite: 227]"

echo "ALL TESTS PASSED SUCCESSFULLY! [cite: 231]"