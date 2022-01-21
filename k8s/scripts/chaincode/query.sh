#!/bin/bash

. /opt/gopath/scripts/utils.sh

title "Querying the chaincode ${CHAINCODE_NAME} by ${CORE_PEER_LOCALMSPID}"

info "Querying the chaincode ${CHAINCODE_NAME} in the channel ${CHANNEL_NAME}"

peer chaincode query \
      --channelID "${CHANNEL_NAME}" \
      --name "${CHAINCODE_NAME}" \
      --ctor '{"Args": ["read", "value1"]}'

result=$?
if [ $result -ne 0 ]; then
    fatal "Failed querying the chaincode ${CHAINCODE_NAME} in the channel ${CHANNEL_NAME}"
fi
