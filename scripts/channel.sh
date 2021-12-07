#!/bin/bash

######################################################################
## Common parameters
######################################################################

export ARTIFACTS_PATH="${CRYPTO_PATH_TOOLS}/channel-artifacts"
export CONFIG_BLOCK_FILE="${ARTIFACTS_PATH}/${CHANNEL_NAME}.block"

######################################################################
## Creating the channel
######################################################################

export ORDERING_SERVICE_NODE_ADDRESS=${ORDERING_SERVICE_REST_ADDRESS_INTERNAL}
export CA_FILE="${CRYPTO_PATH_TOOLS}/ordererOrganizations/${ORDERING_ORG_DOMAIN}/orderers/${ORDERING_SERVICE_NODE_ID}/msp/tlscacerts/tlsca.${ORDERING_ORG_DOMAIN}-cert.pem"
export CLIENT_CERT="${CRYPTO_PATH_TOOLS}/ordererOrganizations/${ORDERING_ORG_DOMAIN}/orderers/${ORDERING_SERVICE_NODE_ID}/tls/server.crt"
export CLIENT_KEY="${CRYPTO_PATH_TOOLS}/ordererOrganizations/${ORDERING_ORG_DOMAIN}/orderers/${ORDERING_SERVICE_NODE_ID}/tls/server.key"

/bin/bash ./scripts/channel/create.sh

######################################################################
## Joining peers to the channel
######################################################################

export ORG_MSP_ID="${ORG1_MSP_ID}"
export PEER_ID="${ORG1_PEER0_ID}"
export PEER_PORT="${ORG1_PEER0_PORT_INTERNAL}"
export MSP_PATH="${CRYPTO_PATH_TOOLS}/peerOrganizations/${ORG1_DOMAIN}/users/Admin@${ORG1_DOMAIN}/msp"
export TLS_ROOTCERT_FILE="${CRYPTO_PATH_TOOLS}/peerOrganizations/${ORG1_DOMAIN}/peers/${PEER_ID}/tls/server.crt"

/bin/bash ./scripts/channel/join.sh

export ORG_MSP_ID="${ORG2_MSP_ID}"
export PEER_ID="${ORG2_PEER0_ID}"
export PEER_PORT="${ORG2_PEER0_PORT_INTERNAL}"
export MSP_PATH="${CRYPTO_PATH_TOOLS}/peerOrganizations/${ORG2_DOMAIN}/users/Admin@${ORG2_DOMAIN}/msp"
export TLS_ROOTCERT_FILE="${CRYPTO_PATH_TOOLS}/peerOrganizations/${ORG2_DOMAIN}/peers/${PEER_ID}/tls/server.crt"

/bin/bash ./scripts/channel/join.sh

######################################################################
## Updating addresses of anchor peers in the channel config
######################################################################

export ORDERING_SERVICE_ADDRESS=${ORDERING_SERVICE_GRPC_ADDRESS_INTERNAL}
export ORDERER_CA_FILE="${CRYPTO_PATH_TOOLS}/ordererOrganizations/${ORDERING_ORG_DOMAIN}/orderers/${ORDERING_SERVICE_NODE_ID}/msp/tlscacerts/tlsca.${ORDERING_ORG_DOMAIN}-cert.pem"

export ORG_MSP_ID="${ORG1_MSP_ID}"
export PEER_ID="${ORG1_PEER0_ID}"
export PEER_PORT="${ORG1_PEER0_PORT_INTERNAL}"
export MSP_PATH="${CRYPTO_PATH_TOOLS}/peerOrganizations/${ORG1_DOMAIN}/users/Admin@${ORG1_DOMAIN}/msp"
export TLS_ROOTCERT_FILE="${CRYPTO_PATH_TOOLS}/peerOrganizations/${ORG1_DOMAIN}/peers/${PEER_ID}/tls/server.crt"

/bin/bash  ./scripts/channel/anchors.sh

export ORG_MSP_ID="${ORG2_MSP_ID}"
export PEER_ID="${ORG2_PEER0_ID}"
export PEER_PORT="${ORG2_PEER0_PORT_INTERNAL}"
export MSP_PATH="${CRYPTO_PATH_TOOLS}/peerOrganizations/${ORG2_DOMAIN}/users/Admin@${ORG2_DOMAIN}/msp"
export TLS_ROOTCERT_FILE="${CRYPTO_PATH_TOOLS}/peerOrganizations/${ORG2_DOMAIN}/peers/${PEER_ID}/tls/server.crt"

/bin/bash  ./scripts/channel/anchors.sh
