#!/bin/bash

. env.sh

PATH=${PWD}/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/config

######################################################################
# ORG 1
######################################################################

echo "Setting the anchor peer for the ORG 1 to the channel ${CHANNEL_NAME}"

export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_ID=peer0.org1.example.com
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_MSPCONFIGPATH=${PEER0_ORG1_MSP}
export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG1_CA}

echo
echo "Fetching config block from channel ${CHANNEL_NAME}"
peer channel fetch config channel-artifacts/${CORE_PEER_LOCALMSPID}block.pb -o localhost:7050 -c "$CHANNEL_NAME" --tls --ordererTLSHostnameOverride orderer.example.com --cafile "$ORDERER_CA"
result=$?
if [ $result -ne 0 ]; then
    echo "Failed fetching config block from the channel ${CHANNEL_NAME}"
    exit 1
fi

configtxlator proto_decode --input channel-artifacts/${CORE_PEER_LOCALMSPID}block.pb --type common.Block --output channel-artifacts/${CORE_PEER_LOCALMSPID}block.json
result=$?
if [ $result -ne 0 ]; then
    echo "Failed decoding config block"
    exit 1
fi

cat channel-artifacts/${CORE_PEER_LOCALMSPID}block.json | jq .data.data[0].payload.data.config > channel-artifacts/${CORE_PEER_LOCALMSPID}config.json

jq '.channel_group.groups.Application.groups.'${CORE_PEER_LOCALMSPID}'.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "'$CORE_PEER_ID'","port": '7051'}]},"version": "0"}}' channel-artifacts/${CORE_PEER_LOCALMSPID}config.json > channel-artifacts/${CORE_PEER_LOCALMSPID}modified_config.json


configtxlator proto_encode --input channel-artifacts/${CORE_PEER_LOCALMSPID}config.json --type common.Config --output channel-artifacts/original_config.pb
configtxlator proto_encode --input channel-artifacts/${CORE_PEER_LOCALMSPID}modified_config.json --type common.Config --output channel-artifacts/modified_config.pb
configtxlator compute_update --channel_id "${CHANNEL_NAME}" --original channel-artifacts/original_config.pb --updated channel-artifacts/modified_config.pb --output channel-artifacts/config_update.pb
configtxlator proto_decode --input channel-artifacts/config_update.pb --type common.ConfigUpdate --output channel-artifacts/config_update.json
echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL_NAME'", "type":2}},"data":{"config_update":'$(cat channel-artifacts/config_update.json)'}}}' | jq . > channel-artifacts/config_update_in_envelope.json
configtxlator proto_encode --input channel-artifacts/config_update_in_envelope.json --type common.Envelope --output "channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx"

peer channel update -o localhost:7050 -c "$CHANNEL_NAME" -f channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls --ordererTLSHostnameOverride orderer.example.com --cafile "$ORDERER_CA"
result=$?
if [ $result -ne 0 ]; then
    echo "Failed decoding config block"
    exit 1
fi

######################################################################
# ORG 2
######################################################################

echo "Setting the anchor peer for the ORG 2 to the channel ${CHANNEL_NAME}"

export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_ID=peer0.org2.example.com
export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_MSPCONFIGPATH=${PEER0_ORG2_MSP}
export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG2_CA}

peer channel fetch config channel-artifacts/${CORE_PEER_LOCALMSPID}block.pb -o localhost:7050 -c "$CHANNEL_NAME" --tls --ordererTLSHostnameOverride orderer.example.com --cafile "$ORDERER_CA"
result=$?
if [ $result -ne 0 ]; then
    echo "Failed fetching config block from the channel ${CHANNEL_NAME}"
    exit 1
fi

configtxlator proto_decode --input channel-artifacts/${CORE_PEER_LOCALMSPID}block.pb --type common.Block --output channel-artifacts/${CORE_PEER_LOCALMSPID}block.json
result=$?
if [ $result -ne 0 ]; then
    echo "Failed decoding config block"
    exit 1
fi

cat channel-artifacts/${CORE_PEER_LOCALMSPID}block.json | jq .data.data[0].payload.data.config > channel-artifacts/${CORE_PEER_LOCALMSPID}config.json

jq '.channel_group.groups.Application.groups.'${CORE_PEER_LOCALMSPID}'.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "'$CORE_PEER_ID'","port": '9051'}]},"version": "0"}}' channel-artifacts/${CORE_PEER_LOCALMSPID}config.json > channel-artifacts/${CORE_PEER_LOCALMSPID}modified_config.json


configtxlator proto_encode --input channel-artifacts/${CORE_PEER_LOCALMSPID}config.json --type common.Config --output channel-artifacts/original_config.pb
configtxlator proto_encode --input channel-artifacts/${CORE_PEER_LOCALMSPID}modified_config.json --type common.Config --output channel-artifacts/modified_config.pb
configtxlator compute_update --channel_id "${CHANNEL_NAME}" --original channel-artifacts/original_config.pb --updated channel-artifacts/modified_config.pb --output channel-artifacts/config_update.pb
configtxlator proto_decode --input channel-artifacts/config_update.pb --type common.ConfigUpdate --output channel-artifacts/config_update.json
echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL_NAME'", "type":2}},"data":{"config_update":'$(cat channel-artifacts/config_update.json)'}}}' | jq . > channel-artifacts/config_update_in_envelope.json
configtxlator proto_encode --input channel-artifacts/config_update_in_envelope.json --type common.Envelope --output "channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx"

peer channel update -o localhost:7050 -c $CHANNEL_NAME -f channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls --ordererTLSHostnameOverride orderer.example.com --cafile "$ORDERER_CA"
result=$?
if [ $result -ne 0 ]; then
    echo "Failed decoding config block"
    exit 1
fi
