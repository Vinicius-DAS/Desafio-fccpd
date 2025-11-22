#!/bin/bash


set -e

echo "==================================="
echo "Desafio 2 - Setup de Volumes"
echo "==================================="
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}[1/3]${NC} Criando volume Docker..."
if docker volume create desafio2-db-data 2>/dev/null; then
    echo -e "${GREEN}✓ Volume 'desafio2-db-data' criado com sucesso${NC}"
else
    echo -e "${YELLOW}⚠ Volume 'desafio2-db-data' já existe${NC}"
fi

echo ""

echo -e "${BLUE}[2/3]${NC} Verificando containers antigos..."
if docker ps -a --filter name=desafio2-db --quiet | grep -q .; then
    echo -e "${YELLOW}⚠ Container 'desafio2-db' já existe, removendo...${NC}"
    docker rm -f desafio2-db > /dev/null
    echo -e "${GREEN}✓ Container antigo removido${NC}"
else
    echo -e "${GREEN}✓ Nenhum container antigo encontrado${NC}"
fi

echo ""

echo -e "${BLUE}[3/3]${NC} Iniciando container PostgreSQL..."
docker run -d \
  --name desafio2-db \
  -e POSTGRES_USER=usuario \
  -e POSTGRES_PASSWORD=senha123 \
  -e POSTGRES_DB=meubanco \
  -v desafio2-db-data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:16 > /dev/null

echo -e "${GREEN}✓ Container iniciado com sucesso${NC}"

echo ""
echo "==================================="
echo -e "${GREEN}Setup concluído!${NC}"
echo "==================================="
echo ""
echo "Próximos passos:"
echo "1. Aguarde 5-10 segundos para o PostgreSQL ficar pronto"
echo "2. Execute: bash demo.sh"
echo ""
echo "Ou conecte manualmente:"
echo "  docker exec -it desafio2-db psql -U usuario -d meubanco"
echo ""
