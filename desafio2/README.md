# Challenge 2 — Volumes and Persistence

## Objective

This challenge demonstrates how to use **Docker volumes** to ensure database **data persistence** even after removing the container.

The idea is to:

- start a container with a PostgreSQL database;
- store the data in a **named volume**;
- create a table and insert some records;
- remove the container;
- start another container using the **same volume** and show that the data is still there.

## Solution Overview

- Database: **PostgreSQL** (official image `postgres:16`).
- Docker Volume: `desafio2-db-data`, mapped to the internal directory where Postgres saves data: `/var/lib/postgresql/data`.
- Main Container:
  - Name: `desafio2-db`
  - Function: execute the PostgreSQL server.
- The persistence proof is performed as follows:
  1. Create the volume and start the container.
  2. Create a table and insert data.
  3. Remove the container.
  4. Start a new container using the **same volume**.
  5. Query the table again and verify that the data remains saved.

> **Important:** It is the **volume** that persists, not the container.
> The container can die, be recreated, renamed, etc., but as long as the volume exists, the data remains there.

## Architecture

### Main Components

- **Docker Volume: `desafio2-db-data`**
  - Type: named volume.
  - Responsible for persisting all PostgreSQL data files.
  - Mapped to `/var/lib/postgresql/data` inside the container.

- **Container `desafio2-db`**
  - Image: `postgres:16`
  - Environment Variables:
    - `POSTGRES_USER=usuario`
    - `POSTGRES_PASSWORD=senha123`
    - `POSTGRES_DB=meubanco`
  - Port:
    - `5432` of the container mapped to `5432` on the host (`-p 5432:5432`).
  - Uses the `desafio2-db-data` volume to store database data.

### Summary Flow

                        +------------------------------+
                        |            Host              |
                        |                              |
                        |   localhost:5432             |
                        |   (mapped port)              |
                        +---------------|--------------+
                                        |
                       -p 5432:5432     |
                                        v
                        +------------------------------+
                        |        Container             |
                        |        "desafio2-db"         |
                        |   image: postgres:16         |
                        |   /var/lib/postgresql/data   |
                        +---------------|--------------+
                                        |
                     -v desafio2-db-data:/var/lib/postgresql/data
                                        |
                                        v
                        +------------------------------+
                        |       Docker Volume          |
                        |      "desafio2-db-data"      |
                        +------------------------------+

## Folder Structure

    desafio2/
    ├── README.md
    ├── setup.sh      # Creates volume and starts container
    ├── demo.sh       # Creates table and inserts data
    ├── persist.sh    # Removes and recreates container to prove persistence
    └── cleanup.sh    # Removes container and volume (reset)

    In this challenge, I used the official PostgreSQL image directly, so no custom Dockerfile was needed. All logic lies in the use of the volume and the commands: docker run, docker exec, and docker volume.

## Fast Execution (Automated)

To run the complete challenge automatically:

    # 1. Quick start (one-line)
    cd desafio2 && bash setup.sh && bash demo.sh && bash persist.sh

    # 2. Setup step-by-step
    bash setup.sh

    # 2. Demo: create table and insert data
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
    
    # 3. Demo: prove persistence (remove and recreate container)
    bash persist.sh

    # 4. Cleanup (optional)
    bash cleanup.sh

## Step-by-Step Execution (Manual)

    The commands below assume that Docker is already installed and running.
    In Windows PowerShell, if you have issues with line breaks, you can run each command on a single line.

    1) Create the docker volume
      docker volume create desafio2-db-data
    
    1.1) (Optional) Check if the volume was created
      docker volume ls

    2) Start the Postgres container using the volume
      docker run -d --name desafio2-db -e POSTGRES_USER=usuario -e POSTGRES_PASSWORD=senha123 -e POSTGRES_DB=meubanco -v desafio2-db-data:/var/lib/postgresql/data -p 5432:5432 postgres:16

    3) Create table and insert data into DB
      docker exec -it desafio2-db psql -U usuario -d meubanco
    -> inside psql run:
        CREATE TABLE clientes (id SERIAL PRIMARY KEY,nome TEXT NOT NULL);

        INSERT INTO clientes (nome) VALUES ('Gabriel'), ('Maria'), ('João');

        SELECT * FROM clientes;

    If the output looks something like this:
    id|nome
    1 | Gabriel
    2 | Maria
    3 | João
    This shows that the database is working and the data has been written to the PostgreSQL data directory, which is linked to the desafio2-db-data volume.

    Use \q to exit psql

    4) Remove the container
      docker rm -f desafio2-db
    
    4.1) (Optional) Check if it is really gone
      docker ps -a
    
    4.2) (Optional) Check if the volume still exists
      docker volume ls

    5) Start new container with the same volume
      docker run -d --name desafio2-db -e POSTGRES_USER=usuario -e POSTGRES_PASSWORD=senha123 -e POSTGRES_DB=meubanco -v desafio2-db-data:/var/lib/postgresql/data -p 5432:5432 postgres:16

    6) Prove persistence
      docker exec -it desafio2-db psql -U usuario -d meubanco
      SELECT * FROM clientes;

    Expected output is the same as before.

## Troubleshooting

### Error: "volume is in use"
If you receive an error when deleting the volume, remove the container first:
```bash
docker rm -f desafio2-db
docker volume rm desafio2-db-data