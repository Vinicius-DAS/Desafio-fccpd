#!/bin/bash


set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "${YELLOW}Aviso: Isso vai remover o volume 'db-data' e todos os dados do Postgres.${NC}"
read -p "Continuar? (s/n) " -n 1 -r

if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo
    echo "Operação cancelada.";
    exit 0;
fi

echo "Parando serviços..."
docker compose down

if docker volume ls | grep -q db-data; then
    docker volume rm db-data
    echo "${GREEN}Volume db-data removido${NC}"
else
    echo "${YELLOW}Volume db-data não existe${NC}"
fi

echo ""
echo "Para recriar os serviços com um banco limpo execute:"
echo "  docker compose up -d --build"
