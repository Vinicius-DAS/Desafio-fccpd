#!/bin/bash


set -e

echo "==================================="
echo "Desafio 1 - Iniciando Containers"
echo "==================================="
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Limpando containers antigos...${NC}"
docker rm -f desafio1-web desafio1-client 2>/dev/null || true

echo ""

echo -e "${BLUE}[1/2]${NC} Iniciando servidor web..."
docker run -d \
  --name desafio1-web \
  --network desafio1-net \
  --network-alias web \
  -p 8080:8080 \
  desafio1-web

echo -e "${GREEN}✓ Servidor iniciado em http://localhost:8080${NC}"

echo ""
sleep 2

echo -e "${BLUE}[2/2]${NC} Iniciando cliente..."
docker run -d \
  --name desafio1-client \
  --network desafio1-net \
  desafio1-client

echo -e "${GREEN}✓ Cliente iniciado (fazendo requisições cada 5 segundos)${NC}"

echo ""
echo "==================================="
echo -e "${GREEN}Containers em execução!${NC}"
echo "==================================="
echo ""
echo "Visualizar logs:"
echo "  docker logs -f desafio1-web"
echo "  docker logs -f desafio1-client"
echo ""
echo "Testar manualmente:"
echo "  curl http://localhost:8080/"
echo ""
echo "Parar:"
echo "  bash cleanup.sh"
echo ""
