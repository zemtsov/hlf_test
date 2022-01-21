#!/bin/bash

# Create channel
osnadmin channel join \
        --channelID "${CHANNEL_NAME}" \
        --config-block /opt/gopath/artifacts/"${CHANNEL_NAME}".block \
        --orderer-address "${ORDERING_SERVICE_REST_ADDRESS}" \
        --ca-file /opt/gopath/crypto/ordererOrganizations/"${ORDERING_ORG_DOMAIN}"/orderers/"${ORDERING_SERVICE_NODE_ID}"/msp/tlscacerts/tlsca."${ORDERING_ORG_DOMAIN}"-cert.pem \
        --client-cert /opt/gopath/crypto/ordererOrganizations/"${ORDERING_ORG_DOMAIN}"/orderers/"${ORDERING_SERVICE_NODE_ID}"/tls/server.crt \
        --client-key /opt/gopath/crypto/ordererOrganizations/"${ORDERING_ORG_DOMAIN}"/orderers/"${ORDERING_SERVICE_NODE_ID}"/tls/server.key
