# Desafio 5 — Microsserviços com API Gateway

## Objetivo

Criar uma arquitetura com **API Gateway** centralizando o acesso a dois microsserviços:

- **Users Service**: fornece dados de usuários.
- **Orders Service**: fornece dados de pedidos.
- **Gateway**: expõe os endpoints `/users` e `/orders` e orquestra as chamadas para os dois serviços.

Todos os serviços são executados em containers Docker, orquestrados via `docker-compose`.



## Arquitetura

- `users-service` (porta interna 5000)
  - `GET /users` → lista de usuários em JSON.
- `orders-service` (porta interna 5000)
  - `GET /orders` → lista de pedidos em JSON.
- `gateway` (porta interna 5000, exposta como 8080 no host)
  - `GET /users` → chama `users-service` via HTTP, devolve resposta agregada.
  - `GET /orders` → chama `orders-service` via HTTP.
  - Usa variáveis de ambiente:
    - `USERS_SERVICE_URL`
    - `ORDERS_SERVICE_URL`
  - Ponto único de entrada para o consumidor externo: `http://localhost:8080`.

Rede:

- Rede interna `desafio5-net`, criada pelo Compose.
- Os serviços se enxergam pelos hostnames:
  - `users-service`
  - `orders-service`
  - `gateway`



## Execução Rápida (Automatizada)

  # 1) Quick start (one-line)
  cd desafio5 && bash setup.sh && bash test.sh

  # 2) Setup step-by-step
  bash setup.sh

  # 2) Testar endpoints via gateway
  bash test.sh

  # 3) Simular falha do users-service
  bash simulate_gateway_failure.sh

  # 4) Parar e limpar
  bash cleanup.sh

## Verify (expected result)

1) Check gateway endpoints:
```bash
curl http://localhost:8080/users
curl http://localhost:8080/orders
```
Expect JSON responses aggregated by the gateway with fields like `via`, `upstream`, and the data arrays.

2) Check that direct service endpoints exist:
```bash
docker compose exec users-service curl -s http://localhost:5000/users
docker compose exec orders-service curl -s http://localhost:5000/orders
```
Expect the original raw JSON returned by each service.

## ▶️ Como executar (Manual)
    Para rodar, voce deve estar na pasta do desafio 5

    1) Criar 
      docker compose up -d --build

    2) Mostrar como esta
      docker compose ps
    
    3) Testar users
      curl http://localhost:8080/users | Select-Object -Expand Content
    
    3.1) Testar orders
      curl http://localhost:8080/orders | Select-Object -Expand Content

    3.2) testar users-service
      docker compose exec users-service curl -s http://localhost:5000/users
    
    3.3) Testar orders-service

  ## Como o Gateway faz o roteamento

  O `gateway` recebe as requisições externas e encaminha internamente:

  - `GET /users` → proxy para `users-service` (http://users-service:5000/users)
  - `GET /orders` → proxy para `orders-service` (http://orders-service:5000/orders)

  As URLs de backend podem ser configuradas via variáveis de ambiente (`USERS_SERVICE_URL`, `ORDERS_SERVICE_URL`) definidas no `docker-compose.yml`.

  ## Troubleshooting

  ### Erro: Gateway retorna erro 502/504
  Verifique se o `users-service`/`orders-service` estão crescendo:
  ```bash
  docker compose ps
  docker compose logs -f gateway
  ```

  ### Erro: Porta 8080 já em uso
  Altere o mapeamento no `docker-compose.yml` ou pare o processo que está usando 8080.

  ### CORS / Timeouts
  Se o gateway retorna tempo limite, verifique os logs do serviço backend e aumente o timeout no gateway (se aplicável).
      docker compose exec orders-service curl -s http://localhost:5000/orders

# Prints

![Descrição da imagem](./print1-desafio5.png)
![Descrição da imagem](./print2-desafio5.png)
![Descrição da imagem](./print3-desafio5.png)
![Descrição da imagem](./print4-desafio5.png)
