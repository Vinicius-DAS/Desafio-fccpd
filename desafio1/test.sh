#!/bin/bash


set -e

echo "Testing server endpoint (saving output to curl_out.json):"
curl -s http://localhost:8080/ | python3 -m json.tool | tee curl_out.json || (curl -s http://localhost:8080/ | tee curl_out.json)

echo ""
echo "Saving last 50 lines of client logs to client_logs.txt"
docker logs --tail 50 desafio1-client | tee client_logs.txt || true

echo ""
echo "Saving container status to containers_status.txt"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | tee containers_status.txt || true

echo ""
echo "Files saved in $(pwd): curl_out.json, client_logs.txt, containers_status.txt"
