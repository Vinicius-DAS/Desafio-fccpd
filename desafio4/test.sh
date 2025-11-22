#!/bin/bash


echo "==================================="
echo "Desafio 4 - Testando Microsserviços"
echo "==================================="
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Aguardando serviços ficarem prontos...${NC}"
sleep 2

echo ""

echo -e "${BLUE}[1/4]${NC} Health check Service A..."
curl -s http://localhost:5000/health | python3 -m json.tool
echo ""

echo -e "${BLUE}[2/4]${NC} Usuários de Service A..."
curl -s http://localhost:5000/users | python3 -m json.tool
echo ""

echo -e "${BLUE}[3/4]${NC} Health check Service B..."
curl -s http://localhost:5001/health | python3 -m json.tool
echo ""

echo -e "${BLUE}[4/4]${NC} Relatório do Service B (consumindo Service A)..."
curl -s http://localhost:5001/report | python3 -m json.tool
echo ""

echo "==================================="
echo -e "${GREEN}Testes concluídos!${NC}"
echo "==================================="
echo ""
