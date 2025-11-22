#!/bin/bash


set -e

echo "==================================="
echo "Desafio 4 - Setup de Microsserviços"
echo "==================================="
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}[1/3]${NC} Criando rede Docker 'desafio4-net'..."
if docker network create desafio4-net 2>/dev/null; then
    echo -e "${GREEN}✓ Rede criada${NC}"
else
    echo -e "${YELLOW}⚠ Rede já existe${NC}"
fi

echo ""

echo -e "${BLUE}[2/3]${NC} Construindo service-a..."
docker build -t desafio4-service-a ./service-a/
echo -e "${GREEN}✓ Imagem construída${NC}"

echo ""

echo -e "${BLUE}[3/3]${NC} Construindo service-b..."
docker build -t desafio4-service-b ./service-b/
echo -e "${GREEN}✓ Imagem construída${NC}"

echo ""
echo "==================================="
echo -e "${GREEN}Setup concluído!${NC}"
echo "==================================="
echo ""
echo "Próximos passos:"
echo "  bash run.sh"
echo ""
