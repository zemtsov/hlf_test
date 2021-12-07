#!/bin/bash

. ./scripts/utils.sh

PEER_ADDRESS="${PEER_ID}:${PEER_PORT}"

title "Invoking the chaincode ${CHAINCODE_NAME} by ${ORG_MSP_ID}"

info "Invoking the chaincode ${CHAINCODE_NAME} in the channel ${CHANNEL_NAME}"
docker exec \
    --env CORE_PEER_TLS_ENABLED=true \
    --env CORE_PEER_LOCALMSPID="${ORG_MSP_ID}" \
    --env CORE_PEER_ID="${PEER_ID}" \
    --env CORE_PEER_ADDRESS="${PEER_ADDRESS}" \
    --env CORE_PEER_MSPCONFIGPATH="${MSP_PATH}" \
    --env CORE_PEER_TLS_ROOTCERT_FILE="${TLS_ROOTCERT_FILE}" \
    "${DOCKER_FABRIC_TOOLS_CONTAINER}" \
    peer chaincode invoke \
          --orderer "${ORDERING_SERVICE_ENDPOINT}" \
          --tls --cafile "${ORDERING_CA_FILE}" \
          --channelID "${CHANNEL_NAME}" \
          --name "${CHAINCODE_NAME}" \
          ${PEER_CONNECTIONS} \
          --ctor '{"Args": ["store", "value1", "value_from_cli"]}'

result=$?
if [ $result -ne 0 ]; then
    fatal "Failed invoking the chaincode ${CHAINCODE_NAME} to the channel ${CHANNEL_NAME}"
fi
