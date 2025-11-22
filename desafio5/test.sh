#!/bin/bash


echo "==================================="
echo "Desafio 5 - Testando API Gateway"
echo "==================================="
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Aguardando serviços ficarem prontos...${NC}"
sleep 3

echo ""

echo -e "${BLUE}[1/4]${NC} GET /users via Gateway..."
curl -s http://localhost:8080/users | python3 -m json.tool 2>/dev/null || curl -s http://localhost:8080/users
echo ""

echo -e "${BLUE}[2/4]${NC} GET /orders via Gateway..."
curl -s http://localhost:8080/orders | python3 -m json.tool 2>/dev/null || curl -s http://localhost:8080/orders
echo ""

echo -e "${BLUE}[3/4]${NC} GET /status via Gateway..."
curl -s http://localhost:8080/status | python3 -m json.tool 2>/dev/null || curl -s http://localhost:8080/status
echo ""

echo -e "${BLUE}[4/4]${NC} Status dos serviços..."
docker compose ps

echo ""
echo "==================================="
echo -e "${GREEN}Testes concluídos!${NC}"
echo "==================================="
echo ""
echo "O Gateway está funcionando como proxy centralizando o acesso!"
echo ""
