#!/bin/bash

. ./scripts/utils.sh

PEER_ADDRESS="${PEER_ID}:${PEER_PORT}"

title "Querying the chaincode ${CHAINCODE_NAME} on the peer ${PEER_ID}"

docker exec \
    --env CORE_PEER_TLS_ENABLED=true \
    --env CORE_PEER_LOCALMSPID="${ORG_MSP_ID}" \
    --env CORE_PEER_ID="${PEER_ID}" \
    --env CORE_PEER_ADDRESS="${PEER_ADDRESS}" \
    --env CORE_PEER_MSPCONFIGPATH="${MSP_PATH}" \
    --env CORE_PEER_TLS_ROOTCERT_FILE="${TLS_ROOTCERT_FILE}" \
    "${DOCKER_FABRIC_TOOLS_CONTAINER}" \
    peer chaincode query \
      --channelID "${CHANNEL_NAME}" \
      --name "${CHAINCODE_NAME}" \
      --ctor '{"Args": ["read", "value1"]}'


result=$?
if [ $result -ne 0 ]; then
    fatal "Failed querying the chaincode ${CHAINCODE_NAME}"
fi

println
