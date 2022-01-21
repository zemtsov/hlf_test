#!/bin/bash

. /opt/gopath/scripts/utils.sh

title "Approving the chaincode package ${CHAINCODE_ID} by ${CORE_PEER_LOCALMSPID}"

info "Approving the chaincode ${CHAINCODE_NAME} from ${CORE_PEER_ADDRESS}"
peer lifecycle chaincode approveformyorg \
      --orderer "${ORDERING_SERVICE_GRPC_ADDRESS}" \
      --tls --cafile "${ORDERING_CA_FILE}" \
      --channelID "${CHANNEL_NAME}" \
      --name "${CHAINCODE_NAME}" \
      --version "${CHAINCODE_VERSION}" \
      --package-id "${CHAINCODE_ID}" \
      --sequence "${CHAINCODE_SEQUENCE}" \
      "${CHAINCODE_INIT}" \
      --signature-policy "${ENDORSEMENT_POLICY}"

result=$?
if [ $result -ne 0 ]; then
    fatal "Failed approving the chaincode ${CHAINCODE_NAME} by the organization ${CORE_PEER_LOCALMSPID} on the peer ${CORE_PEER_ID}"
fi

println
