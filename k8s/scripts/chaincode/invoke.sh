#!/bin/bash

. /opt/gopath/scripts/utils.sh

title "Invoking the chaincode ${CHAINCODE_NAME} by ${CORE_PEER_LOCALMSPID}"

info "Invoking the chaincode ${CHAINCODE_NAME} in the channel ${CHANNEL_NAME}"

peer chaincode invoke \
      --orderer "${ORDERING_SERVICE_GRPC_ADDRESS}" \
      --tls --cafile "${ORDERING_CA_FILE}" \
      --channelID "${CHANNEL_NAME}" \
      --name "${CHAINCODE_NAME}" \
      --peerAddresses "${ORG1_PEER0_ADDRESS}" \
      --tlsRootCertFiles "${ORG1_PEER0_CA_CERT_FILE}" \
      --peerAddresses "${ORG2_PEER0_ADDRESS}" \
      --tlsRootCertFiles "${ORG2_PEER0_CA_CERT_FILE}" \
      --ctor '{"Args": ["store", "value1", "value_from_cli"]}'

result=$?
if [ $result -ne 0 ]; then
    fatal "Failed invoking the chaincode ${CHAINCODE_NAME} in the channel ${CHANNEL_NAME}"
fi
