#!/bin/bash

. ./scripts/utils.sh

title "Starting Hyperledger Fabric ${HLF_VERSION} network"

info "Bringing up the network services"
docker-compose \
      -f "${DOCKER_COMPOSE_CONFIG_PATH}"/network.yaml \
      -f "${DOCKER_COMPOSE_CONFIG_PATH}"/couchdb.yaml \
      -f "${DOCKER_COMPOSE_CONFIG_PATH}"/cli.yaml \
      up -d

println
