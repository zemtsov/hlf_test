#!/bin/bash

. ./scripts/utils.sh

title "Creating the channel ${CHANNEL_NAME}"

info "Ordering service address: ${ORDERING_SERVICE_NODE_ADDRESS}"
info "CA TLS certificate file: ${CA_FILE}"
info "Client TLS certificate file: ${CLIENT_CERT}"
info "Client TLS key file: ${CLIENT_KEY}"
info "Config block file: ${CONFIG_BLOCK_FILE}"

docker exec "${DOCKER_FABRIC_TOOLS_CONTAINER}" sh -c "test -f ${CONFIG_BLOCK_FILE}"
result=$?
if [ $result -ne 0 ]; then
    fatal "The config block file ${CONFIG_BLOCK_FILE} doesn't exist"
fi

docker exec \
      "${DOCKER_FABRIC_TOOLS_CONTAINER}" \
      osnadmin channel join \
      --channelID "${CHANNEL_NAME}" \
      --config-block "${CONFIG_BLOCK_FILE}" \
      --orderer-address "${ORDERING_SERVICE_NODE_ADDRESS}" \
      --ca-file "${CA_FILE}" \
      --client-cert "${CLIENT_CERT}" \
      --client-key "${CLIENT_KEY}"

result=$?
if [ $result -ne 0 ]; then
    fatal "Failed creating the channel ${CHANNEL_NAME}"
fi

println
