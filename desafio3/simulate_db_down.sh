#!/bin/bash


set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Parando serviço db (Postgres)...${NC}"
docker compose stop db || true
sleep 2

echo -e "${BLUE}Consultando http://localhost:8000/ ...${NC}"
set +e
# Faz a requisição e captura o código HTTP (timeout de 3s)
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://localhost:8000/)
RES=$?
set -e

if [ $RES -ne 0 ]; then
    # Erro de rede / timeout: isso é esperado quando o serviço não está respondendo
    echo -e "${GREEN}✓ Web retornou erro quando o DB estava parado (requisicao falhou).${NC} (curl exit=$RES)"
else
    if [ "$HTTP_CODE" -ge 500 ]; then
        echo -e "${GREEN}✓ Web retornou erro de servidor quando o DB estava parado (esperado).${NC} (HTTP=$HTTP_CODE)"
    elif [ "$HTTP_CODE" -ne 200 ]; then
        # 4xx ou outros - significa que a rota não foi encontrada ou está incorreta
        echo -e "${RED}✗ Web respondeu com HTTP $HTTP_CODE — rota incorreta ou endpoint diferente do esperado. Verifique a lógica do app para checar DB status.${NC}"
    else
        # HTTP 200: a aplicacao respondeu normalmente mesmo com BD parado, isso eh incorreto
        echo -e "${RED}✗ Web ainda retornou HTTP 200 (esperado erro quando DB parado). Verifique a lógica do app (checar DB no endpoint).${NC}"
    fi
fi

echo -e "${BLUE}Subindo db novamente...${NC}"
docker compose start db
sleep 2

echo -e "${GREEN}Simulação concluída!${NC}"
