#!/bin/bash


set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Parando service-a...${NC}"
docker rm -f desafio4-service-a 2>/dev/null || true

sleep 2

echo -e "${YELLOW}Testando service-b (deve indicar erro ao consumir service-a)...${NC}"
set +e
curl -s -S http://localhost:5002/report
RES=$?
set -e

if [ $RES -ne 0 ]; then
    echo -e "${GREEN}✓ service-b report falhou como esperado quando service-a está fora${NC}"
else
    echo -e "${RED}✗ service-b ainda respondeu quando service-a foi reiniciado ou já estava disponível${NC}"
fi

echo -e "${BLUE}Subindo service-a novamente...${NC}"
docker run -d --name desafio4-service-a --network desafio4-net --network-alias service-a -p 5003:5000 desafio4-service-a
sleep 2

echo -e "${BLUE}Testando service-b novamente (agora service-a deve estar online)...${NC}"
curl -s http://localhost:5002/report | python3 -m json.tool || true

echo -e "${GREEN}Simulação concluída!${NC}"
