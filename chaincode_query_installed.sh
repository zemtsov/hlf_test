#!/bin/bash

. env.sh

PATH=${PWD}/bin:$PATH

CC_VERSION=${1:-"1"}
CC_SEQUENCE=${2:-1}

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
echo "Querying the list of installed chaincodes on ${CORE_PEER_ID}"

peer lifecycle chaincode queryinstalled >&log.txt
cat log.txt
PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

echo "Package ID is ${PACKAGE_ID}"

######################################################################
# ORG 2
######################################################################

export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_ID=peer0.org2.example.com
export CORE_PEER_ADDRESS=localhost:9051
export CORE_PEER_MSPCONFIGPATH=${PEER0_ORG2_MSP}
export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG2_CA}

echo
echo "Querying the list of installed chaincodes on ${CORE_PEER_ID}"
peer lifecycle chaincode queryinstalled >&log.txt
cat log.txt
PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

echo "Package ID is ${PACKAGE_ID}"

