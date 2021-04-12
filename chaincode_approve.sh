#!/bin/bash

. env.sh

PATH=${PWD}/bin:$PATH

CC_VERSION=${1:-"1"}
CC_SEQUENCE=${2:-1}
INIT_REQUIRED="NA"
CC_END_POLICY="NA"
CC_COLL_CONFIG="NA"

export FABRIC_CFG_PATH=${PWD}/config


######################################################################
# ORG 1
######################################################################

export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_ID=peer0.org1.example.com
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

echo
echo "Querying the list of installed chaincodes on ${CORE_PEER_ID}"

peer lifecycle chaincode queryinstalled >&log.txt
cat log.txt
PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

echo "Package ID is ${PACKAGE_ID}"

echo
echo "Approving the chaincode on ${CORE_PEER_ID}"

peer lifecycle chaincode approveformyorg -o localhost:7050 --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG}

######################################################################
# ORG 2
######################################################################

export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_ID=peer0.org2.example.com
export CORE_PEER_ADDRESS=localhost:9051
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp

echo
echo "Querying the list of installed chaincodes on ${CORE_PEER_ID}"
peer lifecycle chaincode queryinstalled >&log.txt
cat log.txt
PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

echo "Package ID is ${PACKAGE_ID}"

echo
echo "Approving the chaincode on ${CORE_PEER_ID}"

peer lifecycle chaincode approveformyorg -o localhost:7050 --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG}
