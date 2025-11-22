#!/bin/bash


set -e

echo "==================================="
echo "Desafio 4 - Limpeza"
echo "==================================="
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Removendo containers...${NC}"
docker rm -f desafio4-service-a desafio4-service-b 2>/dev/null || echo -e "${YELLOW}Containers não encontrados${NC}"
echo -e "${GREEN}✓ Containers removidos${NC}"

echo ""

echo -e "${BLUE}Removendo rede...${NC}"
docker network rm desafio4-net 2>/dev/null || echo -e "${YELLOW}Rede não encontrada${NC}"
echo -e "${GREEN}✓ Rede removida${NC}"

echo ""
echo "==================================="
echo -e "${GREEN}Limpeza concluída!${NC}"
echo "==================================="
echo ""
