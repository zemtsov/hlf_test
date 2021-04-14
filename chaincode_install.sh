#!/bin/bash

. env.sh

PATH=${PWD}/bin:$PATH

CC_VERSION=${1:-"1"}

export FABRIC_CFG_PATH=${PWD}/config


######################################################################
# ORG 1
######################################################################

export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_ID=peer0.org1.example.com
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_MSPCONFIGPATH=${PEER0_ORG1_MSP}
export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG1_CA}

echo
echo "Installing chaincode ${CC_NAME}, version ${CC_VERSION} on ${CORE_PEER_ID}"

peer lifecycle chaincode install "${CC_SRC_PATH}"/"${CC_NAME}".tar.gz

result=$?
if [ $result -ne 0 ]; then
    echo "Failed installing chaincode on ${CORE_PEER_ID}"
    exit 1
fi

######################################################################
# ORG 2
######################################################################

export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_ID=peer0.org2.example.com
export CORE_PEER_ADDRESS=localhost:9051
export CORE_PEER_MSPCONFIGPATH=${PEER0_ORG2_MSP}
export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG2_CA}

echo
echo "Installing chaincode ${CC_NAME}, version ${CC_VERSION} on ${CORE_PEER_ID}"

peer lifecycle chaincode install "${CC_SRC_PATH}"/"${CC_NAME}".tar.gz

result=$?
if [ $result -ne 0 ]; then
    echo "Failed installing chaincode on ${CORE_PEER_ID}"
    exit 1
fi
