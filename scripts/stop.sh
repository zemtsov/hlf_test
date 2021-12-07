#!/bin/bash

. ./scripts/utils.sh

export IMAGE_TAG=${HLF_VERSION}

title "Stopping Hyperledger Fabric ${IMAGE_TAG} network"

docker-compose \
      -f "${DOCKER_COMPOSE_CONFIG_PATH}"/network.yaml \
      -f "${DOCKER_COMPOSE_CONFIG_PATH}"/couchdb.yaml \
      -f "${DOCKER_COMPOSE_CONFIG_PATH}"/cli.yaml \
      down \
      --volumes \
      --remove-orphans

println
