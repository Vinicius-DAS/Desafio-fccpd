# Challenges-FCCPD

## Prerequisites

- Docker installed (recommended 20.x+)
- Docker Compose (or integrated `docker compose`) — recommended version 2.x+
- Git (optional for cloning the repo)
- Bash (automation scripts use bash)
- Python 3 (for test scripts that format JSON with `python3 -m json.tool`)

  ## Quick run matrix 

  Below are the single-line commands that run the main demo for each challenge (recommended to run from the repo root):

  | Challenge | Run command | Expected outcome |
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
