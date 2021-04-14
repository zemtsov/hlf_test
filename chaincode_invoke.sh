#!/bin/bash

. env.sh

PATH=${PWD}/bin:$PATH

export FABRIC_CFG_PATH=${PWD}/config


######################################################################
# ORG 1
######################################################################

echo
echo "Invoke chaincode ${CC_NAME} from ORG 1"

export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_ID=peer0.org1.example.com
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_MSPCONFIGPATH=${PEER0_ORG1_MSP}
export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG1_CA}

PEER_CONN_PARAMS="--peerAddresses localhost:7051 $(eval echo "--tlsRootCertFiles \$PEER0_ORG1_CA") --peerAddresses localhost:9051 $(eval echo "--tlsRootCertFiles \$PEER0_ORG2_CA")"

peer chaincode invoke -C "$CHANNEL_NAME" -o localhost:7050 --tls --ordererTLSHostnameOverride orderer.example.com --cafile "$ORDERER_CA" -n "${CC_NAME}" $PEER_CONN_PARAMS -c '{"Args": ["store", "value1", "value_from_cli"]}' >&log.txt

cat log.txt
