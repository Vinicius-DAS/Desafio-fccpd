# Challenge 4 — Independent Microservices

## Objective

Create **two independent microservices** that communicate via HTTP:

- **Microservice A (service-a)**: exposes a list of users in JSON.
- **Microservice B (service-b)**: consumes service A, combines the information and returns a "report" with sentences like  
  `"User X active since Y"`.

Each microservice runs in a **separate Docker container**, with its own Dockerfile, and communication happens via HTTP using a **custom Docker network (`desafio4-net`)**.



## Solution Architecture

### Overview

- **service-a**
  - Framework: Flask (Python).
  - Endpoint principal: `GET /users`
  - Retorna uma lista fixa de usuários em JSON, por exemplo:
    ```json
    [
      {"id": 1, "name": "Gabriel", "active_since": "2023-01-10"},
      {"id": 2, "name": "Maria",   "active_since": "2022-09-02"},
      {"id": 3, "name": "João",    "active_since": "2021-05-15"}
    ]
    ```
  - Health endpoint: `GET /health` → `{"status": "ok"}`

- **service-b**
  - Framework: Flask (Python) + `requests`.
  - Main endpoint: `GET /report`
    - Calls microservice A via HTTP.
    - Reads the JSON from `/users`.
    - Builds sentences like:
      ```text
      "User Gabriel active since 2023-01-10"
      ```
    - Returns a JSON like:
      ```json
      {
        "source": "http://service-a:5000/users",
        "total_users": 3,
        "messages": [
          "User Gabriel active since 2023-01-10",
          "User Maria active since 2022-09-02",
          "User João active since 2021-05-15"
        ]
      }
      ```
  - Health endpoint: `GET /health` → `{"status": "ok"}`
  - Service A URL is configured via environment variable `USERS_API_URL`.

### Docker Network

- Network: **`desafio4-net`**
  - Created manually with `docker network create`.
  - Connects `service-a` and `service-b` containers.
  - Within the network, `service-b` accesses `service-a` by hostname `service-a` on port `5000`.

### Diagram (conceptual)


               +---------------------------+
               |        Host (PC)          |
               |                           |
               |  http://localhost:5003   --> service-a (/users)
               |  http://localhost:5002   --> service-b (/report)
               +---------------------------+

                 (Docker network: desafio4-net)
                          |
          +---------------+---------------+ 
          |                               |
     +-------------+                 +-------------+
     |  service-a  |  <--- HTTP ---  |  service-b  |
     | Flask /users|                 | Flask/report|
     +-------------+                 +-------------+

## Folder Structure
```
desafio4/
├── service-a/
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
├── service-b/
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
```

## Quick Execution (Automated)

  # 1) Quick start (one-line)
  cd desafio4 && bash setup.sh && bash run.sh && bash test.sh

  # 2) Setup (separated)
  bash setup.sh

  # 2) Start microservices
  bash run.sh

  # 3) Test automatically
  bash test.sh

  # 4) Simulate service-a failure
  bash simulate_failure.sh

  # 5) Clean up everything
  bash cleanup.sh

## Verify (expected result)

1) Check service-a users list:
```bash
curl http://localhost:5003/users
```
Expect JSON list of users (id, name, active_since).

2) Check service-b report:
```bash
curl http://localhost:5002/report
```
Expect JSON with `source`, `total_users` and an array of `messages` with sentences like "User Gabriel active since 2023-01-10".

## How to execute (manual)
    All commands below are executed from the desafio4 folder

    1) Create Docker network
      docker network create desafio4-net

    2) Build images
    2.1) service-a
        docker build -t desafio4-service-a ./service-a
    2.2) service-b
        docker build -t desafio4-service-b ./service-b

    3) Start Microservice A
        docker run -d --name service-a --network desafio4-net -p 5003:5000 desafio4-service-a

    3.2) Start Microservice B
        docker run -d --name service-b --network desafio4-net -p 5002:5000 -e USERS_API_URL=http://service-a:5000/users desafio4-service-b

    4) Check if containers are running
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

    5) Test microservice A
        curl http://localhost:5003/users
    5.1) Test B
      curl http://localhost:5002/report

  ## Troubleshooting

  ### Service B fails to consume A
  If `service-b` cannot reach `service-a`, check:
  - If both containers are on the same network `desafio4-net`.
  - If the `USERS_API_URL` variable is correctly pointing to `http://service-a:5000/users`.
  Check logs:
  ```bash
  docker logs -f desafio4-service-b
  ```

  ### Port occupied
  If `5003` or `5002` is occupied on the host, use another port mapping in `docker run`.

  ### Checking availability
  To test if `service-a` is responding:
  ```bash
  curl http://localhost:5003/users
  ```

  To test `service-b`:
  ```bash
  curl http://localhost:5002/report
  ``` 

# Prints

![Image description](./print1-desafio4.png)
![Image description](./print2-desafio4.png)
![Image description](./print3-desafio4.png)




