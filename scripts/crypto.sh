#!/bin/bash

. ./scripts/utils.sh

title "Generating crypto materials and artifacts"

info "Starting Fabric Tools container"
docker-compose -f "${DOCKER_COMPOSE_CONFIG_PATH}"/cli.yaml up -d

info "Generating crypto materials for organizations"
docker exec "${DOCKER_FABRIC_TOOLS_CONTAINER}" cryptogen generate \
      --config="${CRYPTO_PATH_TOOLS}"/cryptogen.yaml \
      --output="${CRYPTO_PATH_TOOLS}"

info "Generating the genesis block for the channel ${CHANNEL_NAME}"
docker exec "${DOCKER_FABRIC_TOOLS_CONTAINER}" configtxgen \
      -configPath "${CRYPTO_PATH_TOOLS}" \
      -profile "${GENESIS_BLOCK_PROFILE}" \
      -outputBlock "${CRYPTO_PATH_TOOLS}"/channel-artifacts/"${CHANNEL_NAME}".block \
      -channelID "${CHANNEL_NAME}"

info "Cleaning..."
docker-compose -f "${DOCKER_COMPOSE_CONFIG_PATH}"/cli.yaml down --volumes --remove-orphans

println
