#!/bin/bash

# Script de Teste - Desafio 2: salva outputs úteis pra prova (tabelas e logs)

set -e

OUT_DIR=$(pwd)

echo "Saving DB table contents to db_table_contents.txt"
docker exec -i desafio2-db psql -U usuario -d meubanco -c "SELECT * FROM clientes;" | tee "$OUT_DIR/db_table_contents.txt"

echo ""
echo "Saving postgres container logs to db_container_logs.txt"
docker logs desafio2-db --tail 200 | tee "$OUT_DIR/db_container_logs.txt"

echo ""
echo "Saving docker ps to containers_status.txt"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | tee "$OUT_DIR/containers_status.txt"

echo ""
echo "Saving docker volume list to volumes.txt"
docker volume ls | tee "$OUT_DIR/volumes.txt"

echo ""
echo "Files saved in: $OUT_DIR"

echo "Done. Open these files to take screenshots or attach to delivery."
