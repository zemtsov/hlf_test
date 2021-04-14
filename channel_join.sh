#!/bin/bash

. env.sh

PATH=${PWD}/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/config

######################################################################
# ORG 1
######################################################################

echo "Joining peer0.org1.example.com to the channel ${CHANNEL_NAME}"

export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_ID=peer0.org1.example.com
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_MSPCONFIGPATH=${PEER0_ORG1_MSP}
export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG1_CA}

peer channel join -b ./channel-artifacts/"${CHANNEL_NAME}".block

result=$?
if [ $result -ne 0 ]; then
    echo "Failed joining peer0.org1.example.com to the channel ${CHANNEL_NAME}"
fi

######################################################################
# ORG 2
######################################################################

echo "Joining peer0.org2.example.com to the channel ${CHANNEL_NAME}"

export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_ID=peer0.org2.example.com
export CORE_PEER_ADDRESS=localhost:9051
export CORE_PEER_MSPCONFIGPATH=${PEER0_ORG2_MSP}
export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG2_CA}

peer channel join -b ./channel-artifacts/"${CHANNEL_NAME}".block

result=$?
if [ $result -ne 0 ]; then
    echo "Failed joining peer0.org2.example.com to the channel ${CHANNEL_NAME}"
fi

