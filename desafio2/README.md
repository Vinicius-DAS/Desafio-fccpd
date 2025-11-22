# Desafio 2 — Volumes e Persistência

## Objetivo

Este desafio demonstra como usar **volumes Docker** para garantir a **persistência de dados** de um banco de dados mesmo após remover o container.

A ideia é:

- subir um container com um banco PostgreSQL;
- armazenar os dados em um **volume nomeado**;
- criar uma tabela e inserir alguns registros;
- remover o container;
- subir outro container usando o **mesmo volume** e mostrar que os dados continuam lá.



## Visão Geral da Solução

- Banco de dados: **PostgreSQL** (imagem oficial `postgres:16`).
- Volume Docker: `desafio2-db-data`, mapeado para o diretório interno onde o Postgres salva os dados: `/var/lib/postgresql/data`.
- Container principal:
  - Nome: `desafio2-db`
  - Função: executar o servidor PostgreSQL.
- A prova de persistência é feita assim:
  1. Criar volume e subir o container.
  2. Criar uma tabela e inserir dados.
  3. Remover o container.
  4. Subir um novo container usando o **mesmo volume**.
  5. Consultar a tabela novamente e verificar que os dados continuam salvos.

> **Importante:** o que persiste não é o container, e sim o **volume**.  
> O container pode morrer, ser recriado, renomeado, etc., mas enquanto o volume existir, os dados continuam lá.



## Arquitetura

### Componentes principais

- **Volume Docker: `desafio2-db-data`**
  - Tipo: volume nomeado.
  - Responsável por persistir todos os arquivos de dados do PostgreSQL.
  - Mapeado em `/var/lib/postgresql/data` dentro do container.

- **Container `desafio2-db`**
  - Imagem: `postgres:16`
  - Variáveis de ambiente:
    - `POSTGRES_USER=usuario`
    - `POSTGRES_PASSWORD=senha123`
    - `POSTGRES_DB=meubanco`
  - Porta:
    - `5432` do container mapeada para `5432` no host (`-p 5432:5432`).
  - Usa o volume `desafio2-db-data` para armazenar os dados do banco.

### Fluxo resumido

                        +------------------------------+
                        |            Host              |
                        |                              |
psql / cliente externo  |   localhost:5432             |
----------------------> |   (porta mapeada)            |
                        +---------------|--------------+
                                        |
                       -p 5432:5432     |
                                        v
                        +------------------------------+
                        |        Container             |
                        |        "desafio2-db"         |
                        |   imagem: postgres:16        |
                        |   /var/lib/postgresql/data   |
                        +---------------|--------------+
                                        |
                     -v desafio2-db-data:/var/lib/postgresql/data
                                        |
                                        v
                        +------------------------------+
                        |       Volume Docker          |
                        |      "desafio2-db-data"      |
                        +------------------------------+

## Estrutura de Pastas
    desafio2/
    ├── README.md
    ├── setup.sh      # Cria volume e inicia container
    ├── demo.sh       # Cria tabela e insere dados
    ├── persist.sh    # Remove e recria container para provar persistência
    └── cleanup.sh    # Remove container e volume (reset)

    Neste desafio usei diretamente a imagem oficial do PostgreSQL, então não precisei de Dockerfile customizado. Toda a lógica está no uso do volume e dos comandos docker run, docker exec e docker volume.

## Execução Rápida (Automática)

Para executar o desafio completo de forma automatizada:

    # 1. Quick start (one-line)
    cd desafio2 && bash setup.sh && bash demo.sh && bash persist.sh

    # 2. Setup step-by-step
    bash setup.sh

    # 2. Demo: criar tabela e inserir dados
    bash demo.sh

    ## Verify (expected result)

    1) Verify table contents:
    ```bash
    docker exec -it desafio2-db psql -U usuario -d meubanco -c "SELECT * FROM clientes;"
    ```
    Expect rows:
    ```
     id |  nome
    ----+---------
     1 | Gabriel
     2 | Maria
     3 | João
    ```

    2) After `persist.sh`, run the same SELECT to confirm data persisted.
    # 3. Demo: provar persistência (remove e recria container)
    bash persist.sh

    # 4. Limpar tudo (opcional)
    bash cleanup.sh

## Passo a passo para execução (Manual)
    Os comandos abaixo assumem que o Docker já está instalado e rodando.
    No Windows PowerShell, se tiver problema com quebras de linha, você pode rodar cada comando em uma linha só.

    1) Criar o volume docker
      docker volume create desafio2-db-data
    1.1) (Opcional) Verifica se o volume foi criado
      docker volume ls

    2) Subir o container do Postgres usando o volume
      docker run -d --name desafio2-db -e POSTGRES_USER=usuario -e POSTGRES_PASSWORD=senha123 -e POSTGRES_DB=meubanco -v desafio2-db-data:/var/lib/postgresql/data -p 5432:5432 postgres:16

    3) Criação de tabela e a inserção dela no BD
      docker exec -it desafio2-db psql -U usuario -d meubanco
    -> dentro do psql voce roda:
        CREATE TABLE clientes (id SERIAL PRIMARY KEY,nome TEXT NOT NULL);

        INSERT INTO clientes (nome) VALUES ('Gabriel'), ('Maria'), ('João');

        SELECT * FROM clientes;

    se a saida tiver algo como:
    id|nome
    1 | Gabriel
    2 | Maria
    3 | João
    Isso mostra que o banco está funcionando e os dados foram gravados no diretório de dados do PostgreSQL, que está ligado ao volume desafio2-db-data.

    Use \q para sair do psql

    4) Para remover o container
      docker rm -f desafio2-db
    4.1) (Opcional) Verifica se realmente sumiu
      docker ps -a
    4.2) (Opcional) Veja se o volume ainda existe
      docker volume ls

    5) Subir novo container com mesmo volume
      docker run -d --name desafio2-db -e POSTGRES_USER=usuario -e POSTGRES_PASSWORD=senha123 -e POSTGRES_DB=meubanco -v desafio2-db-data:/var/lib/postgresql/data -p 5432:5432 postgres:16

    6) Provar a persistencia 
      docker exec -it desafio2-db psql -U usuario -d meubanco
      SELECT * FROM clientes;

    saída esperada é a mesma da outra.

## Troubleshooting

### Erro: "volume is in use"
Se receber erro ao deletar o volume, primeiro remova o container:
```bash
docker rm -f desafio2-db
docker volume rm desafio2-db-data
```

### Erro: "bind: address already in use"
A porta 5432 já está em uso. Opções:
- Remover o container: `docker rm -f desafio2-db`
- Usar outra porta: adicionar `-p 5433:5432` (usar 5433 no cliente)

### PostgreSQL não conecta logo após iniciar
O PostgreSQL leva alguns segundos para ficar pronto. Aguarde 5-10 segundos antes de conectar.

### Erro ao executar scripts
Conceda permissão de execução:
```bash
chmod +x setup.sh demo.sh persist.sh cleanup.sh
```

## Conceitos-Chave

**Volume vs Container:**
- **Container**: é efêmero, morre e leva seus dados junto (se não usar volume)
- **Volume**: é persistente, sobrevive à morte do container

**Por que volumes são importantes:**
- Dados de banco de dados precisam persistir
- Separar a infraestrutura de dados da aplicação
- Facilitar backup e migração de dados

## Prints
![Descrição da imagem](./criação%20do%20bd.jpeg)

nessa imagem de cima eu crio o banco de dados


![Descrição da imagem](./remoção%20do%20container.jpeg)

removo o container para provar a persistencia


![Descrição da imagem](./container%20sumiu.jpeg)

confiro se ele realmente foi removido


![Descrição da imagem](./volume%20é%20o%20mesmo.jpeg)


Mostro que houve persistencia uma vez que com a remoção, os dados continuaram e nao foram excluidos

## Checklist para avaliação
- ✅ Código funcionando: instruções de `docker run`, `docker volume` e uso de `postgres:16` corretos
- ✅ README com scripts: `setup.sh`, `demo.sh`, `persist.sh`, `cleanup.sh`
- ✅ Prova de persistência com prints e instruções passo a passo
- ✅ Troubleshooting incluído para problemas comuns (porta, volume, permissões)

