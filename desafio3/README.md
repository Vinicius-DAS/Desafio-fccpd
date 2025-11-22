# Desafio 3 — Docker Compose Orquestrando Serviços

## Objetivo

Usar **Docker Compose** para orquestrar uma aplicação composta por **3 serviços**:

- `web`: aplicação Flask que expõe uma API HTTP.
- `db`: banco de dados PostgreSQL.
- `cache`: serviço de cache Redis.

A aplicação web se comunica com o banco e com o cache via rede interna criada pelo Compose.


## Arquitetura

### Serviços

- **web (desafio3-web)**
  - Imagem construída a partir de `web/Dockerfile`.
  - Porta exposta: `5000` (mapeada para `8000` no host).
  - Tecnologias: Python, Flask, psycopg2, Redis.
  - Lê variáveis de ambiente (`DB_HOST`, `DB_USER`, etc.) definidas no `docker-compose.yml`.
  - Funções principais:
    - Cria tabela `visitas` no Postgres (se não existir).
    - Insere um novo registro a cada requisição.
    - Conta quantos registros existem.
    - Incrementa um contador de visitas no Redis (`visitas_home`).

- **db (desafio3-db)**
  - Imagem: `postgres:16`.
  - Variáveis de ambiente:
    - `POSTGRES_USER=usuario`
    - `POSTGRES_PASSWORD=senha123`
    - `POSTGRES_DB=desafio3db`
  - Usa o volume nomeado `db-data` para persistir os dados.
  - Acessado pelo hostname `db` dentro da rede `desafio3-net`.

- **cache (desafio3-cache)**
  - Imagem: `redis:7`.
  - Acessado pelo hostname `cache`.
  - Armazena o contador de visitas em memória.

### Rede e Volumes

- Rede interna: `desafio3-net`
  - Criada automaticamente pelo Compose.
  - Todos os três serviços estão conectados nela.
  - Permite que o `web` acesse `db` e `cache` pelos hostnames.

- Volume: `db-data`
  - Armazena os dados do PostgreSQL.
  - Declarado em `volumes:` no `docker-compose.yml`.


## Estrutura do Projeto

desafio3/
├── docker-compose.yml
├── setup.sh        # Inicia a stack com Docker Compose
├── test.sh         # Testa endpoints da aplicação
├── reset-db.sh     # Remove volume e recria database limpo
├── cleanup.sh      # Para e remove os serviços
└── web/
  ├── Dockerfile
  ├── requirements.txt
  └── app.py

## Execução Rápida (Automática)

  # 1) Quick start (one-line)
  cd desafio3 && bash setup.sh && bash test.sh

  # 2) Automated steps (split)
  bash setup.sh
  bash test.sh

    # 3) Simular falha do DB (verificar fallback/status)
    bash simulate_db_down.sh
    # 4) Reset do banco de dados (apaga volume db-data)
    bash reset-db.sh

    # 4) Limpar toda a stack
    bash cleanup.sh

  ## Verify (expected result)

  1) Check web endpoint:
  ```bash
  curl http://localhost:8000/
  ```
  Expect JSON including keys: `db_status`, `redis_status`, `total_registros_db`, `visitas_redis`.

  2) Confirm the ping tests:
  ```bash
  docker compose exec web ping -c 2 db
  docker compose exec web ping -c 2 cache
  ```
  Expect successful ping responses.

## Passo a passo de execução (Manual)

    1) Subir serviços
      docker compose up -d --build
    1.1) (Opcional) verificação
      docker compose ps

    2) Acessar aplicação
      curl http://localhost:8000 | Select-Object -Expand Content

    3) Teste de comunicação
      docker compose exec web ping -c 2 db
      docker compose exec web ping -c 2 cache

    #Prints

![Descrição da imagem](./ping%20web.jpeg)

Prova que o serviço web consegue resolver o hostname db na rede interna e se comunicar com o Postgres.

![Descrição da imagem](./ping%20cache.jpeg)

Prova que o web também fala com o Redis (cache) na mesma rede.

![Descrição da imagem](./curl.jpeg)

Prova que o endpoint da aplicação está funcionando e que:

    db_status = "ok" → comunicação com o Postgres

    redis_status = "ok" → comunicação com o Redis

    total_registros_db e visitas_redis estão sendo atualizados

![Descrição da imagem](./compose.jpeg)

isso evidencia o Compose orquestrando os 3 serviços.

## Checklist para avaliação
- ✅ Código funcionando: `docker-compose.yml` e `web/Dockerfile` prontos
- ✅ README com instruções e scripts: `setup.sh`, `test.sh`, `reset-db.sh`, `cleanup.sh`
- ✅ Testes básicos automatizados integram os serviços (`bash test.sh`)
- ✅ Troubleshooting adicionado para problemas comuns (ports, volumes)

## Troubleshooting

### Erro: "bind: address already in use"
Se a porta 8000 já estiver ocupada, use outra porta ao iniciar o Compose:
```bash
docker compose down
# Defina a variável de ambiente ou edite o compose para usar 8001:5000
docker compose up -d --build
```

### Erro: "volume is in use" ao remover volume
Certifique-se que os serviços foram parados antes de remover volume:
```bash
docker compose down
docker volume rm db-data
```

### Web não conecta ao Postgres
1. Verifique se as variáveis de ambiente em `docker-compose.yml` estão corretas (DB_HOST=db)
2. Acesse o container web e rode pings:
```bash
docker compose exec web ping -c 3 db
docker compose exec web bash -c "psql -h db -U usuario -d desafio3db -c '\dt'" || true
```

## Conceitos-Chave

- Docker Compose cria redes por padrão, portanto os serviços se comunicam por hostname.
- Volumes persistem dados do Postgres enquanto existir o volume `db-data`.
- Use `docker compose down -v` para remover volumes com cuidado.