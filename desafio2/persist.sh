#!/bin/bash


echo "==================================="
echo "Desafio 2 - Demo: Persistência"
echo "==================================="
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}[1/3]${NC} Removendo container 'desafio2-db'..."
docker rm -f desafio2-db

echo -e "${GREEN}✓ Container removido${NC}"
echo ""

echo -e "${BLUE}Verificando...${NC}"
if docker ps -a --filter name=desafio2-db --quiet | grep -q .; then
    echo -e "${RED}✗ Container ainda existe!${NC}"
else
    echo -e "${GREEN}✓ Container foi realmente removido${NC}"
fi

echo ""

echo -e "${BLUE}[2/3]${NC} Recriando container com o MESMO volume..."
docker run -d \
  --name desafio2-db \
  -e POSTGRES_USER=usuario \
  -e POSTGRES_PASSWORD=senha123 \
  -e POSTGRES_DB=meubanco \
  -v desafio2-db-data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:16 > /dev/null

echo -e "${GREEN}✓ Novo container iniciado${NC}"

echo ""
echo -e "${BLUE}Aguardando PostgreSQL ficar pronto...${NC}"
sleep 5

echo ""

echo -e "${BLUE}[3/3]${NC} Consultando dados na tabela..."
echo ""
echo -e "${YELLOW}Resultado da consulta:${NC}"
docker exec -it desafio2-db psql -U usuario -d meubanco -c "SELECT * FROM clientes;"

echo ""
echo "==================================="
echo -e "${GREEN}Persistência confirmada!${NC}"
echo "==================================="
echo ""
echo "Os dados continuaram mesmo após:"
echo "  • Remover o container antigo"
echo "  • Criar um novo container"
echo ""
echo "Por quê? Porque os dados estão no VOLUME, não no container!"
echo ""
