#!/bin/bash

. env.sh

PATH=${PWD}/bin:$PATH

export FABRIC_CFG_PATH=${PWD}/config


######################################################################
# ORG 1
######################################################################

echo
echo "Querying chaincode ${CC_NAME} from ORG 1"

export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_ID=peer0.org1.example.com
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_MSPCONFIGPATH=${PEER0_ORG1_MSP}
export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG1_CA}

peer chaincode query -C "$CHANNEL_NAME" -n "${CC_NAME}" -c '{"Args": ["read", "init"]}' >&log.txt

cat log.txt


######################################################################
# ORG 2
######################################################################

echo
echo "Querying chaincode ${CC_NAME} from ORG 2"

export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_ID=peer0.org2.example.com
export CORE_PEER_ADDRESS=localhost:9051
export CORE_PEER_MSPCONFIGPATH=${PEER0_ORG2_MSP}
export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG2_CA}

peer chaincode query -C "$CHANNEL_NAME" -n "${CC_NAME}" -c '{"Args": ["read", "init"]}' >&log.txt

#docker exec \
#    -e "CORE_PEER_LOCALMSPID=Org2MSP" \
#    -e "CORE_PEER_ID=peer0.org2.example.com" \
#    -e "CORE_PEER_ADDRESS=peer0.org2.example.com:9051" \
#    -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp" \
#    cli \
#    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args": ["read", "value1"]}' >&log.txt

cat log.txt

