#!/bin/bash


echo "==================================="
echo "Desafio 2 - Demo: Criar e Inserir"
echo "==================================="
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Aguardando PostgreSQL ficar pronto...${NC}"
sleep 5

echo ""
echo -e "${BLUE}[1/2]${NC} Criando tabela 'clientes'..."
docker exec -it desafio2-db psql -U usuario -d meubanco -c "CREATE TABLE clientes (id SERIAL PRIMARY KEY, nome TEXT NOT NULL);" 2>/dev/null || echo -e "${YELLOW}⚠ Tabela pode já existir${NC}"

echo -e "${GREEN}✓ Tabela criada${NC}"

echo ""
echo -e "${BLUE}[2/2]${NC} Inserindo dados na tabela..."
docker exec -it desafio2-db psql -U usuario -d meubanco -c "INSERT INTO clientes (nome) VALUES ('Gabriel'), ('Maria'), ('João');"

echo -e "${GREEN}✓ Dados inseridos${NC}"

echo ""
echo -e "${BLUE}Resultado da consulta:${NC}"
docker exec -it desafio2-db psql -U usuario -d meubanco -c "SELECT * FROM clientes;"

echo ""
echo "==================================="
echo -e "${GREEN}Demo concluído!${NC}"
echo "==================================="
echo ""
echo "Próximos passos:"
echo "1. Execute: bash persist.sh (para remover e recriar o container)"
echo "2. Verifique que os dados ainda existem"
echo ""
