# Desafios-FCCPD

## Prerequisitos (o que precisa antes de começar)

- Docker instalado (recomendado 20.x+)
- Docker Compose (ou `docker compose` integrado) — recomendado versão 2.x+
- Git (opcional para clonar o repo)
- Bash (scripts de automação usam bash)
- Python 3 (para os scripts de teste que formatam JSON com `python3 -m json.tool`)

## Conselhos do desafio
   Para cada desafio é importante derrubar eles após cada teste.

   PARA O DESAFIO 1:
   
     Quando terminar usar o comando:
     
     bash desafio1/cleanup.sh
     
     e depois o comando:
     
     # (This command is no longer needed)

   PARA O DESAFIO 2:
   
     Quando terminar usar o comando:
     
     bash desafio2/cleanup.sh

   Para O DESAFIO 3:
   
     Quando terminar usar o comando:
     
        bash desafio3/cleanup.sh

   PARA O DESAFIO 4:
   
     Quando terminar usar o comando:
     
     bash desafio4/cleanup.sh
     
     e depois o comando:
     
     # (This command is no longer needed)

   PARA O DESAFIO 5:
   
     Quando terminar usar o comando:
     
       bash desafio5/cleanup.sh

    ## Scripts úteis por desafio
    - `desafio1`: `setup.sh`, `run.sh`, `test.sh`, `cleanup.sh`
    - `desafio2`: `setup.sh`, `demo.sh`, `persist.sh`, `cleanup.sh`
    - `desafio3`: `setup.sh`, `test.sh`, `reset-db.sh`, `cleanup.sh`
    - `desafio4`: `setup.sh`, `run.sh`, `test.sh`, `simulate_failure.sh`, `cleanup.sh`
    - `desafio5`: `setup.sh`, `test.sh`, `simulate_gateway_failure.sh`, `cleanup.sh`

    ## Run everything automatically

    If you want to run all challenges one after another (setup, test and cleanup), use the root script:

    ```bash
    bash run_all.sh
    ```

    The script will prompt for confirmation before running destructive or state-changing commands.

  ## Quick run matrix (one-line commands)

  Below are the single-line commands that run the main demo for each desafio (recommended to run from the repo root):

  | Desafio | Run command | Expected outcome |
  |---|---|---|
  | `desafio1` | `cd desafio1 && bash setup.sh && bash run.sh && bash test.sh` | Web endpoint at http://localhost:8080 returns JSON, client logs show requests |
  | `desafio2` | `cd desafio2 && bash setup.sh && bash demo.sh && bash persist.sh` | Postgres container starts, table `clientes` with 3 records; after `persist.sh` the same data remains |
  | `desafio3` | `cd desafio3 && bash setup.sh && bash test.sh` | Compose stack runs; `http://localhost:8000/` returns status including DB and Redis OK |
  | `desafio4` | `cd desafio4 && bash setup.sh && bash run.sh && bash test.sh` | `service-a` and `service-b` start and `GET /report` shows aggregated messages |
  | `desafio5` | `cd desafio5 && bash setup.sh && bash test.sh` | Gateway `http://localhost:8080/users` and `/orders` return aggregated responses |

  ## Troubleshooting Quick Tips

  - If a port is occupied, change the host port mapping in the `run` commands; example: `-p 8081:8080`.
  - If a script fails, check logs with `docker logs -f <container>` or `docker compose logs -f`.
  - For Compose projects, use `docker compose down -v` to remove volumes if needed (careful — this deletes DB data).
  - If a script needs execution permission: `chmod +x <script>.sh`.

  If you want a guided checklist for each challenge, open the challenge's `README.md`.

  ## Conformidade com critérios do professor (PDF)
  Cada desafio está alinhado com os seguintes itens solicitados no PDF:

  - Código funcional com Docker/Docker Compose ✅
  - README com execução passo-a-passo ✅
  - Demonstrações práticas (prints or commands) ✅
  - Scripts de automação para setup/test/cleanup ✅
  - Troubleshooting / erros comuns documentados ✅
  - Simulações de falha / comprovação de persistência (quando aplicável) ✅

  Se quiser, posso exportar essa lista como um checklist consolidado que pode ser usada para auto-avaliação.
