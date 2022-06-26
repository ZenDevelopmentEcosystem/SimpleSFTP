#!/bin/env bash
# Run docker compose in module context.
#
set -eu -o pipefail

PROJECT_NAME=simple-sftp
ENV_FILE=./.env

ARGS=("$@")

function run-docker-compose() {
    local compose_args=()
    if [ -f "./local-docker-compose.yml" ]; then
        compose_args+=("-f" "./local-docker-compose.yml")
    fi
    if [ -f "${ENV_FILE}" ]; then
         compose_args+=("--env-file" "${ENV_FILE}")
    fi
    compose_args+=("-f" "./docker-compose.yml")
    compose_args+=("-p" "${PROJECT_NAME}")
    docker-compose "${compose_args[@]}" "${ARGS[@]}"
}

export HOSTNAME=${PROJECT_NAME}

run-docker-compose
