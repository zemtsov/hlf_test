#!/bin/bash

. env.sh

PATH=${PWD}/bin:$PATH

echo "Creating channel ${CHANNEL_NAME}"

export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_ID=peer0.org1.example.com
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_MSPCONFIGPATH=${PEER0_ORG1_MSP}
export FABRIC_CFG_PATH=${PWD}/config

peer channel create -o localhost:7050 -c ${CHANNEL_NAME} -f ${PWD}/channel-artifacts/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block --tls --ordererTLSHostnameOverride orderer.example.com --cafile "$ORDERER_CA"

result=$?
if [ $result -ne 0 ]; then
    echo "Failed creating channel ${CHANNEL_NAME}"
fi
