#!/bin/bash


set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Parando users-service...${NC}"
docker compose stop users-service || true
sleep 2

echo -e "${YELLOW}Testando gateway /users (deve retornar erro ou fallback)...${NC}"
set +e
curl -s -S http://localhost:8080/users
RES=$?
set -e

if [ $RES -ne 0 ]; then
    echo -e "${GREEN}✓ Gateway demonstrou falha ao encaminhar para users-service${NC}"
else
    echo -e "${RED}✗ Gateway respondeu mesmo com users-service parado (verifique fallback implementado)${NC}"
fi

echo -e "${BLUE}Subindo users-service novamente...${NC}"
docker compose start users-service
sleep 2

echo -e "${BLUE}Testando gateway /users novamente...${NC}"
curl -s http://localhost:8080/users | python3 -m json.tool || true

echo -e "${GREEN}Simulação concluída!${NC}"
