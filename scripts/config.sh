#!/bin/bash

. scripts/utils.sh

title "Generating config files from templates"

info "Creating the directory ${DOCKER_COMPOSE_CONFIG_PATH}"
mkdir -p "${DOCKER_COMPOSE_CONFIG_PATH}"

info "Creating the directory ${CRYPTO_PATH_HOST}"
mkdir -p "${CRYPTO_PATH_HOST}"

info "Preparing cryptogen.yaml config file from the template ${TEMPLATES_PATH}/cryptogen-template.yaml"
eval "echo \"$(< ${TEMPLATES_PATH}/crypto/cryptogen-template.yaml )\"" > "${CRYPTO_PATH_HOST}"/cryptogen.yaml

info "Preparing configtx.yaml config file from the template ${TEMPLATES_PATH}/configtx-template.yaml"
eval "echo \"$(< ${TEMPLATES_PATH}/crypto/configtx-template.yaml )\"" > "${CRYPTO_PATH_HOST}"/configtx.yaml

info "Preparing docker compose file cli.yaml from the template ${TEMPLATES_PATH}/docker-compose-cli-template.yaml"
eval "echo \"$(< ${TEMPLATES_PATH}/docker/docker-compose-cli-template.yaml )\"" > "${DOCKER_COMPOSE_CONFIG_PATH}"/cli.yaml

info "Preparing docker compose file network.yaml from the template ${TEMPLATES_PATH}/docker-compose-network-template.yaml"
eval "echo \"$(< ${TEMPLATES_PATH}/docker/docker-compose-network-template.yaml )\"" > "${DOCKER_COMPOSE_CONFIG_PATH}"/network.yaml

info "Preparing docker compose file couchdb.yaml from the template ${TEMPLATES_PATH}/docker-compose-couch-template.yaml"
eval "echo \"$(< ${TEMPLATES_PATH}/docker/docker-compose-couch-template.yaml )\"" > "${DOCKER_COMPOSE_CONFIG_PATH}"/couchdb.yaml

info "Preparing connection profiles for applications"
eval "echo \"$(< ${TEMPLATES_PATH}/connection-profiles/connection-org1-template.json )\"" > "application"/connection-org1.json
eval "echo \"$(< ${TEMPLATES_PATH}/connection-profiles/connection-org1-template.yaml )\"" > "application"/connection-org1.yaml
eval "echo \"$(< ${TEMPLATES_PATH}/connection-profiles/connection-org2-template.json )\"" > "application"/connection-org2.json
eval "echo \"$(< ${TEMPLATES_PATH}/connection-profiles/connection-org2-template.yaml )\"" > "application"/connection-org2.yaml

println
