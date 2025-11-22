#!/bin/bash


set -e

echo "==================================="
echo "Desafio 5 - Limpeza"
echo "==================================="
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Parando serviços...${NC}"
docker compose down

echo ""
echo "==================================="
echo -e "${GREEN}Limpeza concluída!${NC}"
echo "==================================="
echo ""
