#!/bin/bash


set -e

echo "==================================="
echo "Desafio 3 - Setup Docker Compose"
echo "==================================="
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ ! -f docker-compose.yml ]; then
    echo -e "${RED}✗ docker-compose.yml não encontrado!${NC}"
    exit 1
fi

echo -e "${BLUE}Iniciando serviços com Docker Compose...${NC}"
docker compose up -d --build

echo ""
echo "==================================="
echo -e "${GREEN}Setup concluído!${NC}"
echo "==================================="
echo ""
echo "Status dos serviços:"
docker compose ps

echo ""
echo "Próximos passos:"
echo "  bash test.sh"
echo ""
echo "Logs:"
echo "  docker compose logs -f web"
echo ""
echo "Parar:"
echo "  bash cleanup.sh"
echo ""
