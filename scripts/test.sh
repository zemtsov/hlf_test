#!/bin/bash

######################################################################
## Common parameters
######################################################################

export ORDERING_SERVICE_NODE_ADDRESS=${ORDERING_SERVICE_GRPC_ADDRESS_INTERNAL}
export ORDERING_CA_FILE="${CRYPTO_PATH_TOOLS}/ordererOrganizations/${ORDERING_ORG_DOMAIN}/orderers/${ORDERING_SERVICE_NODE_ID}/msp/tlscacerts/tlsca.${ORDERING_ORG_DOMAIN}-cert.pem"

######################################################################
## Invoke and query the chaincode
######################################################################

export ORG1_PEER0_CA_CERT_FILE="${CRYPTO_PATH_TOOLS}/peerOrganizations/${ORG1_DOMAIN}/peers/${ORG1_PEER0_ID}/tls/ca.crt"
export ORG2_PEER0_CA_CERT_FILE="${CRYPTO_PATH_TOOLS}/peerOrganizations/${ORG2_DOMAIN}/peers/${ORG2_PEER0_ID}/tls/ca.crt"
export PEER_CONNECTIONS="--peerAddresses ${ORG1_PEER0_ID}:${ORG1_PEER0_PORT_INTERNAL} --tlsRootCertFiles ${ORG1_PEER0_CA_CERT_FILE} --peerAddresses ${ORG2_PEER0_ID}:${ORG2_PEER0_PORT_INTERNAL} --tlsRootCertFiles ${ORG2_PEER0_CA_CERT_FILE}"

export ORG_MSP_ID="${ORG1_MSP_ID}"
export PEER_ID="${ORG1_PEER0_ID}"
export PEER_PORT="${ORG1_PEER0_PORT_INTERNAL}"
export MSP_PATH="${CRYPTO_PATH_TOOLS}/peerOrganizations/${ORG1_DOMAIN}/users/Admin@${ORG1_DOMAIN}/msp"
export TLS_ROOTCERT_FILE="${CRYPTO_PATH_TOOLS}/peerOrganizations/${ORG1_DOMAIN}/peers/${PEER_ID}/tls/server.crt"

/bin/bash ./scripts/chaincode/invoke.sh
sleep 2
/bin/bash ./scripts/chaincode/query.sh

export ORG_MSP_ID="${ORG2_MSP_ID}"
export PEER_ID="${ORG2_PEER0_ID}"
export PEER_PORT="${ORG2_PEER0_PORT_INTERNAL}"
export MSP_PATH="${CRYPTO_PATH_TOOLS}/peerOrganizations/${ORG2_DOMAIN}/users/Admin@${ORG2_DOMAIN}/msp"
export TLS_ROOTCERT_FILE="${CRYPTO_PATH_TOOLS}/peerOrganizations/${ORG2_DOMAIN}/peers/${PEER_ID}/tls/server.crt"

/bin/bash ./scripts/chaincode/query.sh
