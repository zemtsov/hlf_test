#!/bin/bash

. env.sh

PATH=${PWD}/bin:$PATH

export FABRIC_CFG_PATH=${PWD}/config


######################################################################
# ORG 1
######################################################################

echo
echo "Init chaincode ${CC_NAME} from ORG 1"

export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_ID=peer0.org1.example.com
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_MSPCONFIGPATH=${PEER0_ORG1_MSP}
export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG1_CA}

PEER_CONN_PARAMS="--peerAddresses localhost:7051 $(eval echo "--tlsRootCertFiles \$PEER0_ORG1_CA") --peerAddresses localhost:9051 $(eval echo "--tlsRootCertFiles \$PEER0_ORG2_CA")"

peer chaincode invoke -C "$CHANNEL_NAME" -o localhost:7050 --tls --ordererTLSHostnameOverride orderer.example.com --cafile "$ORDERER_CA" -n "${CC_NAME}" $PEER_CONN_PARAMS --isInit -c '{"Args": []}' >&log.txt

#docker exec \
#    -e "CORE_PEER_LOCALMSPID=Org1MSP" \
#    -e "CORE_PEER_ID=peer0.org1.example.com" \
#    -e "CORE_PEER_ADDRESS=peer0.org1.example.com:7051" \
#    -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp" \
#    cli \
#    peer chaincode invoke -C $CHANNEL_NAME -o orderer.example.com:7050 -n ${CC_NAME} --peerAddresses peer0.org1.example.com:7051 --peerAddresses peer0.org2.example.com:9051 --isInit -c '{"Args": []}' >&log.txt

cat log.txt
