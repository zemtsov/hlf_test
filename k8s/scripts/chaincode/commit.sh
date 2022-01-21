#!/bin/bash

. /opt/gopath/scripts/utils.sh

title "Committing the chaincode package ${CHAINCODE_NAME} by ${CORE_PEER_LOCALMSPID}"

info "Committing the chaincode ${CHAINCODE_NAME} to the channel ${CHANNEL_NAME}"
peer lifecycle chaincode commit \
      --orderer "${ORDERING_SERVICE_GRPC_ADDRESS}" \
      --tls --cafile "${ORDERING_CA_FILE}" \
      --channelID "${CHANNEL_NAME}" \
      --name "${CHAINCODE_NAME}" \
      --version "${CHAINCODE_VERSION}" \
      --sequence "${CHAINCODE_SEQUENCE}" \
      --signature-policy "${ENDORSEMENT_POLICY}" \
      --peerAddresses "${ORG1_PEER0_ADDRESS}" \
      --tlsRootCertFiles "${ORG1_PEER0_CA_CERT_FILE}" \
      --peerAddresses "${ORG2_PEER0_ADDRESS}" \
      --tlsRootCertFiles "${ORG2_PEER0_CA_CERT_FILE}"

result=$?
if [ $result -ne 0 ]; then
    fatal "Failed committing the chaincode ${CHAINCODE_NAME} to the channel ${CHANNEL_NAME}"
fi
