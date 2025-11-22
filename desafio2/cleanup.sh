#!/bin/bash


set -e

echo "==================================="
echo "Desafio 2 - Limpeza e Reset"
echo "==================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}⚠ Aviso: Esta ação vai remover o container E o volume!${NC}"
echo -e "${YELLOW}Todos os dados serão perdidos.${NC}"
echo ""
read -p "Tem certeza? (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Operação cancelada."
    exit 0
fi

echo ""

echo "Removendo container..."
docker rm -f desafio2-db 2>/dev/null || echo -e "${YELLOW}Container não encontrado${NC}"
echo -e "${GREEN}✓ Container removido${NC}"

echo ""

echo "Removendo volume..."
docker volume rm desafio2-db-data 2>/dev/null || echo -e "${YELLOW}Volume não encontrado${NC}"
echo -e "${GREEN}✓ Volume removido${NC}"

echo ""
echo "==================================="
echo -e "${GREEN}Limpeza concluída!${NC}"
echo "==================================="
echo ""
echo "Para reiniciar o desafio:"
echo "  bash setup.sh"
echo ""
