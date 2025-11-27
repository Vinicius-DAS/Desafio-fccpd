# Challenge 1 — Networked Containers

## Objective

This challenge aims to create **two Docker containers** that communicate with each other via a **custom Docker network**.
The idea is to demonstrate, practically, how to:

- create a named Docker network;
- connect multiple containers to this network;
- expose a port to the host;
- make a "client" container consume an HTTP service from another container.

## Solution Overview

The solution consists of two containers:

- **Web Server (`desafio1-web`)**
  - Implemented in **Python + Flask**.
  - Responds on port **8080** with a JSON containing a message, timestamp, and the container hostname.
  - Image based on `python:3.12-slim`.

- **Client (`desafio1-client`)**
  - Implemented in **shell script** running in a container based on `alpine`.
  - Uses `curl` in an infinite loop to make periodic HTTP requests to the server.
  - Every ~5 seconds it makes a request to `http://web:8080` and displays the response in the terminal (note that the server was initialized with the network-alias `web`).

Both containers are connected to the same **custom Docker network** named `desafio1-net`, which allows the client to access the server using the hostname `web`.

## Architecture and Flow

### Components

- **Docker Network**
  - Name: `desafio1-net`
  - Type: bridge (internal network created by Docker)
  - Function: allow `web` and `client` containers to resolve each other by name.

- **Container `web`**
  - Image: `desafio1-web`
  - Port exposed in container: `8080`
  - Port mapped on host: `8080` → `8080`
  - Main Endpoint: `GET /`
  - Response (example):

    ```json
    {
      "message": "Hello, I am the web server of Challenge 1",
      "timestamp": "2025-11-13T17:47:40.338887Z",
      "host": "c30c9f7dc15a"
    }
    ```

- **Container `client`**
  - Image: `desafio1-client`
  - Entry script: `request_loop.sh`
  - Behavior:
    - Prints a startup message.
    - Enters an infinite loop:
      - runs `curl http://web:8080`;
      - prints the response body (JSON);
      - waits 5 seconds and repeats.

### Diagram (conceptual)


                +--------------------------+
                |        Host (PC)         |
                |                          |
                |  http://localhost:8080   |
                |          |               |
                |          v               |
                |    [ Port 8080 ]         |
                +-----------|--------------+
                            |
                 (port mapping host → container)
                            |
                            v
                +--------------------------+
                |     Container "web"      |
                |   Image: desafio1-web    |
                |   Flask on 0.0.0.0:8080  |
                +--------------------------+
                            ^
                            |
                 (Docker network "desafio1-net")
                            |
                            v
                +--------------------------+
                |    Container "client"    |
                | Image: desafio1-client   |
                | curl http://web:8080     |
                +--------------------------+


## Challenge 1 Folder Structure

    Inside the desafio1/ folder:

    desafio1/
    ├── server/
    │   ├── app.py          # Flask Server
    │   └── Dockerfile      # Server Dockerfile
    └── client/
        ├── request_loop.sh # Script that calls the server in a loop
        └── Dockerfile      # Client Dockerfile

## Main Files
    -server/app.py
    -server/Dockerfile
    -client/request_loop.sh
    -client/Dockerfile

## Execution Step-by-Step
    Docker installed and running.

    Terminal (PowerShell / CMD / WSL).

    All commands below assume you are at the root of the repository.

      C:\Users\...> cd C:\Users\...\Desafios-FCCPD

    # Create a docker network

      docker network create desafio1-net
      docker network ls

    # Build images
    1) server
        cd server
        docker build -t desafio1-web .
    2) client
        cd ../client
        docker build -t desafio1-client .
    
    # Start the web server
      docker run -d --name desafio1-web --network desafio1-net -p 8080:8080 desafio1-web

    # Verify if the container is running (Optional)
        docker ps

    # Test server from host
        curl http://localhost:8080 | Select-Object -Expand Content

    This is the command I used because you only see the JSON; if you use just "curl http://localhost:8080", the terminal gets cluttered.

    # Start the client that makes requests in a loop
      docker run --name desafio1-client --network desafio1-net desafio1-client

  ## Quick Execution (Automated)

    # 1) Quick start (one-line)
    cd desafio1 && bash setup.sh && bash run.sh && bash test.sh

    # 2) Automated steps (same as above, broken down)
    bash setup.sh
    bash run.sh
    bash test.sh

  ## Verify (expected result)

  1) Check web endpoint:
  ```bash
  curl http://localhost:8080/
