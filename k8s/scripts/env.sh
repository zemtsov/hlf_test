#!/bin/bash

######################################################################
# Crypto materials and artifacts
######################################################################

export ARTIFACTS_PATH=/opt/gopath/artifacts
export CRYPTO_PATH=/opt/gopath/crypto
export SCRIPT_PATH=/opt/gopath/scripts
export SOURCE_PATH=/opt/gopath/src

export GENESIS_BLOCK_PROFILE=Genesis
export CHANNEL_NAME=primary

######################################################################
# Ordering service
######################################################################

export ORDERING_ORG_NAME=ordering
export ORDERING_ORG_MSP_ID=OrdererOrg
export ORDERING_ORG_DOMAIN=example.com

export ORDERING_SERVICE_NODE_NAME=orderer
export ORDERING_SERVICE_NODE_ID=${ORDERING_SERVICE_NODE_NAME}.${ORDERING_ORG_DOMAIN}
export ORDERING_SERVICE_HOST=${ORDERING_ORG_NAME}-${ORDERING_SERVICE_NODE_NAME}-svc
export ORDERING_SERVICE_GRPC_PORT=7050
export ORDERING_SERVICE_GRPC_ADDRESS=${ORDERING_SERVICE_HOST}:${ORDERING_SERVICE_GRPC_PORT}
export ORDERING_SERVICE_REST_PORT=7053
export ORDERING_SERVICE_REST_ADDRESS=${ORDERING_SERVICE_HOST}:${ORDERING_SERVICE_REST_PORT}
export ORDERING_CA_FILE="${CRYPTO_PATH}/ordererOrganizations/${ORDERING_ORG_DOMAIN}/orderers/${ORDERING_SERVICE_NODE_ID}/msp/tlscacerts/tlsca.${ORDERING_ORG_DOMAIN}-cert.pem"


######################################################################
# Peer organizations
######################################################################

export ORG1_NAME=org1
export ORG1_MSP_ID=Org1
export ORG1_DOMAIN=org1.example.com

export ORG1_PEER0_NAME=peer0
export ORG1_PEER0_PORT=7051
export ORG1_PEER0_ID=${ORG1_PEER0_NAME}.${ORG1_DOMAIN}
export ORG1_PEER0_HOST=${ORG1_NAME}-${ORG1_PEER0_NAME}-svc
export ORG1_PEER0_ADDRESS=${ORG1_PEER0_HOST}:${ORG1_PEER0_PORT}
export ORG1_PEER0_CA_CERT_FILE="${CRYPTO_PATH}/peerOrganizations/${ORG1_DOMAIN}/peers/${ORG1_PEER0_ID}/tls/ca.crt"

export ORG2_NAME=Org2
export ORG2_NAME=org2
export ORG2_MSP_ID=Org2
export ORG2_DOMAIN=org2.example.com

export ORG2_PEER0_NAME=peer0
export ORG2_PEER0_PORT=9051
export ORG2_PEER0_ID=${ORG2_PEER0_NAME}.${ORG2_DOMAIN}
export ORG2_PEER0_HOST=${ORG2_NAME}-${ORG2_PEER0_NAME}-svc
export ORG2_PEER0_ADDRESS=${ORG2_PEER0_HOST}:${ORG2_PEER0_PORT}
export ORG2_PEER0_CA_CERT_FILE="${CRYPTO_PATH}/peerOrganizations/${ORG2_DOMAIN}/peers/${ORG2_PEER0_ID}/tls/ca.crt"

export CORE_PEER_TLS_ENABLED=true

useOrganization() {
  local ORG=${1}

  if [ "${ORG}" -eq 1 ]; then
    export ORG_NAME=${ORG1_NAME}
    export CORE_PEER_LOCALMSPID="${ORG1_MSP_ID}"
    export CORE_PEER_ID="${ORG1_PEER0_ID}"
    export CORE_PEER_ADDRESS="${ORG1_PEER0_ADDRESS}"
    export CORE_PEER_MSPCONFIGPATH="${CRYPTO_PATH}/peerOrganizations/${ORG1_DOMAIN}/users/Admin@${ORG1_DOMAIN}/msp"
    export CORE_PEER_TLS_ROOTCERT_FILE="${CRYPTO_PATH}/peerOrganizations/${ORG1_DOMAIN}/peers/${ORG1_PEER0_ID}/tls/server.crt"
    export ANCHOR_PEER_HOST=${ORG1_PEER0_HOST}
    export ANCHOR_PEER_PORT=${ORG1_PEER0_PORT}

  elif [ "${ORG}" -eq 2 ]; then
    export ORG_NAME=${ORG2_NAME}
    export CORE_PEER_LOCALMSPID="${ORG2_MSP_ID}"
    export CORE_PEER_ID="${ORG2_PEER0_ID}"
    export CORE_PEER_ADDRESS="${ORG2_PEER0_ADDRESS}"
    export CORE_PEER_MSPCONFIGPATH="${CRYPTO_PATH}/peerOrganizations/${ORG2_DOMAIN}/users/Admin@${ORG2_DOMAIN}/msp"
    export CORE_PEER_TLS_ROOTCERT_FILE="${CRYPTO_PATH}/peerOrganizations/${ORG2_DOMAIN}/peers/${ORG2_PEER0_ID}/tls/server.crt"
    export ANCHOR_PEER_HOST=${ORG2_PEER0_HOST}
    export ANCHOR_PEER_PORT=${ORG2_PEER0_PORT}

  else
    echo "Unknown organization ${ORG}"
    exit 1
  fi
}

######################################################################
# Chaincodes
######################################################################

export CHAINCODE_NAME=hello
export CHAINCODE_VERSION=3
export CHAINCODE_LABEL=${CHAINCODE_NAME}_${CHAINCODE_VERSION}
export CHAINCODE_SEQUENCE=3
export CHAINCODE_PORT=7070
export CHAINCODE_INIT=""
export CHAINCODE_POLICY="AND('${ORG1_MSP_ID}.peer','${ORG2_MSP_ID}.peer')"
