#!/bin/bash

. ./scripts/utils.sh

PEER_ADDRESS="${PEER_ID}:${PEER_PORT}"

title "Installing the chaincode ${CHAINCODE_NAME} onto ${PEER_ID}"

info "Installing the chaincode package ${CHAINCODE_PACKAGE}"
docker exec \
    --env CORE_PEER_TLS_ENABLED=true \
    --env CORE_PEER_LOCALMSPID="${ORG_MSP_ID}" \
    --env CORE_PEER_ID="${PEER_ID}" \
    --env CORE_PEER_ADDRESS="${PEER_ADDRESS}" \
    --env CORE_PEER_MSPCONFIGPATH="${MSP_PATH}" \
    --env CORE_PEER_TLS_ROOTCERT_FILE="${TLS_ROOTCERT_FILE}" \
    "${DOCKER_FABRIC_TOOLS_CONTAINER}" \
    peer lifecycle chaincode install "${CHAINCODE_PACKAGE}"

result=$?
if [ $result -ne 0 ]; then
    fatal "Failed installing the chaincode ${CHAINCODE_NAME} to the peer ${PEER_ID} of the organization ${ORG_MSP_ID}"
fi

println
