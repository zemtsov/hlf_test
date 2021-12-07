#!/bin/bash

. ./scripts/utils.sh

PEER_ADDRESS="${PEER_ID}:${PEER_PORT}"

title "Joining ${PEER} of the organization ${ORG_MSP_ID} to the channel ${CHANNEL_NAME}"

info "Peer endpoint: ${PEER_ADDRESS}"
info "MSP path: ${MSP_PATH}"
info "TLS root certificate file: ${TLS_ROOTCERT_FILE}"
info "Config block file: ${CONFIG_BLOCK_FILE}"

docker exec "${DOCKER_FABRIC_TOOLS_CONTAINER}" sh -c "test -f ${CONFIG_BLOCK_FILE}"
result=$?
if [ $result -ne 0 ]; then
    fatal "The config block file ${CONFIG_BLOCK_FILE} doesn't exist"
fi

docker exec \
      --env CORE_PEER_TLS_ENABLED=true \
      --env CORE_PEER_LOCALMSPID="${ORG_MSP_ID}" \
      --env CORE_PEER_ID="${PEER_ID}" \
      --env CORE_PEER_ADDRESS="${PEER_ADDRESS}" \
      --env CORE_PEER_MSPCONFIGPATH="${MSP_PATH}" \
      --env CORE_PEER_TLS_ROOTCERT_FILE="${TLS_ROOTCERT_FILE}" \
      "${DOCKER_FABRIC_TOOLS_CONTAINER}" \
      peer channel join -b "${CONFIG_BLOCK_FILE}"

result=$?
if [ $result -ne 0 ]; then
    error "Failed joining ${PEER} of the organization ${ORG_MSPID} to the channel ${CHANNEL_NAME}"
fi

println
