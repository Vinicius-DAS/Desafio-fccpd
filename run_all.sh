#!/bin/bash

set -euo pipefail

SLEEP_SHORT=3
SLEEP_LONG=6

read -p "This will run all demos and then clean them up. Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborting. No changes made."
  exit 0
fi

run_if_exists() {
  local path="$1"
  shift
  if [ -f "$path" ]; then
    (cd "$(dirname "$path")" && echo "\n--- Running: $path ---" && bash "$(basename "$path")" "$@")
  else
    echo "(Skip) $path not found"
  fi
}

echo "\n=======================\nDesafio 1: Containers em Rede\n======================="
run_if_exists "desafio1/setup.sh"
sleep ${SLEEP_SHORT}
run_if_exists "desafio1/run.sh"
sleep ${SLEEP_SHORT}
run_if_exists "desafio1/test.sh"
sleep ${SLEEP_SHORT}
run_if_exists "desafio1/cleanup.sh"

echo "\n=======================\nDesafio 2: Volumes e Persistência\n======================="
run_if_exists "desafio2/setup.sh"
sleep ${SLEEP_SHORT}
run_if_exists "desafio2/demo.sh"
sleep ${SLEEP_SHORT}
run_if_exists "desafio2/persist.sh"
run_if_exists "desafio2/cleanup.sh"

echo "\n=======================\nDesafio 3: Docker Compose\n======================="
run_if_exists "desafio3/setup.sh"
sleep ${SLEEP_LONG}
run_if_exists "desafio3/test.sh"
sleep ${SLEEP_SHORT}
run_if_exists "desafio3/simulate_db_down.sh"
sleep ${SLEEP_SHORT}
run_if_exists "desafio3/reset-db.sh"
sleep ${SLEEP_SHORT}
run_if_exists "desafio3/cleanup.sh"

echo "\n=======================\nDesafio 4: Microsserviços Independentes\n======================="
run_if_exists "desafio4/setup.sh"
sleep ${SLEEP_SHORT}
run_if_exists "desafio4/run.sh"
sleep ${SLEEP_SHORT}
run_if_exists "desafio4/test.sh"
sleep ${SLEEP_SHORT}
run_if_exists "desafio4/simulate_failure.sh"
sleep ${SLEEP_SHORT}
run_if_exists "desafio4/cleanup.sh"

echo "\n=======================\nDesafio 5: API Gateway\n======================="
run_if_exists "desafio5/setup.sh"
sleep ${SLEEP_LONG}
run_if_exists "desafio5/test.sh"
sleep ${SLEEP_SHORT}
run_if_exists "desafio5/simulate_gateway_failure.sh"
sleep ${SLEEP_SHORT}
run_if_exists "desafio5/cleanup.sh"


echo "\nAll steps executed. If you saw any errors, please check the corresponding logs with docker/docker compose commands."

exit 0
