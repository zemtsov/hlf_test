#!/bin/bash

. ./scripts/utils.sh

title "Cleaning generated files"

info "Crypto materials..."
if [ -d "${CRYPTO_PATH_HOST}" ]
then
  rm -rf "${CRYPTO_PATH_HOST}"
fi

info "Docker compose files..."
if [ -d "${DOCKER_COMPOSE_CONFIG_PATH}" ]
then
  rm -rf "${DOCKER_COMPOSE_CONFIG_PATH}"
fi

info "Connection profiles..."
if [ -f "application"/connection-org1.json ]
then
  rm "application"/connection-org1.json
fi
if [ -f "application"/connection-org1.yaml ]
then
  rm "application"/connection-org1.yaml
fi
if [ -f "application"/connection-org2.json ]
then
  rm "application"/connection-org2.json
fi
if [ -f "application"/connection-org2.yaml ]
then
  rm "application"/connection-org2.yaml
fi

info "Application wallets"
if [ -d "application/wallet" ]
then
  rm -rf "application/wallet"
fi


println
