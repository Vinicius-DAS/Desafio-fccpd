#!/bin/bash


set -e

echo "==================================="
echo "Desafio 4 - Iniciando Microsserviços"
echo "==================================="
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Limpando containers antigos...${NC}"
docker rm -f desafio4-service-a desafio4-service-b 2>/dev/null || true

echo ""

echo -e "${BLUE}[1/2]${NC} Iniciando Service A..."
docker run -d \
  --name desafio4-service-a \
  --network desafio4-net \
  --network-alias service-a \
  -p 5000:5000 \
  desafio4-service-a

echo -e "${GREEN}✓ Service A rodando em http://localhost:5000${NC}"

echo ""
sleep 2

echo -e "${BLUE}[2/2]${NC} Iniciando Service B..."
docker run -d \
  --name desafio4-service-b \
  --network desafio4-net \
  --network-alias service-b \
  -p 5001:5000 \
  desafio4-service-b

echo -e "${GREEN}✓ Service B rodando em http://localhost:5001${NC}"

echo ""
echo "==================================="
echo -e "${GREEN}Microsserviços em execução!${NC}"
echo "==================================="
echo ""
echo "Testes:"
echo "  bash test.sh"
echo ""
echo "Logs:"
echo "  docker logs -f desafio4-service-a"
echo "  docker logs -f desafio4-service-b"
echo ""
echo "Parar:"
echo "  bash cleanup.sh"
echo ""
