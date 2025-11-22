#!/bin/bash


set -e

echo "==================================="
echo "Desafio 1 - Setup de Rede"
echo "==================================="
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}[1/3]${NC} Criando rede Docker 'desafio1-net'..."
if docker network create desafio1-net 2>/dev/null; then
    echo -e "${GREEN}✓ Rede criada com sucesso${NC}"
else
    echo -e "${YELLOW}⚠ Rede 'desafio1-net' já existe${NC}"
fi

echo ""

echo -e "${BLUE}[2/3]${NC} Construindo imagem do servidor..."
docker build -t desafio1-web ./server/
echo -e "${GREEN}✓ Imagem 'desafio1-web' construída${NC}"

echo ""

echo -e "${BLUE}[3/3]${NC} Construindo imagem do cliente..."
docker build -t desafio1-client ./client/
echo -e "${GREEN}✓ Imagem 'desafio1-client' construída${NC}"

echo ""
echo "==================================="
echo -e "${GREEN}Setup concluído!${NC}"
echo "==================================="
echo ""
echo "Próximos passos:"
echo "  bash run.sh"
echo ""
