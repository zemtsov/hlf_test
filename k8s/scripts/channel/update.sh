#!/bin/bash

ARTIFACTS_PATH=/tmp/

peer channel fetch config \
  "${ARTIFACTS_PATH}"/block.pb \
  --orderer "${ORDERING_SERVICE_GRPC_ADDRESS}" \
  --channelID "${CHANNEL_NAME}" \
  --tls \
  --cafile /opt/gopath/crypto/ordererOrganizations/"${ORDERING_ORG_DOMAIN}"/msp/tlscacerts/tlsca."${ORDERING_ORG_DOMAIN}"-cert.pem

result=$?
if [ $result -ne 0 ]; then
    exit 1
fi

configtxlator proto_decode --input "${ARTIFACTS_PATH}/block.pb" --type common.Block --output "${ARTIFACTS_PATH}/block.json"

result=$?
if [ $result -ne 0 ]; then
    exit 1
fi

jq .data.data[0].payload.data.config < "${ARTIFACTS_PATH}/block.json" > "${ARTIFACTS_PATH}/config.json"

jq ".channel_group.groups.Application.groups.${CORE_PEER_LOCALMSPID}.values += {\"AnchorPeers\":{\"mod_policy\": \"Admins\",\"value\":{\"anchor_peers\": [{\"host\": \"${ANCHOR_PEER_HOST}\",\"port\": ${ANCHOR_PEER_PORT}}]},\"version\": \"0\"}}" "${ARTIFACTS_PATH}/config.json" > "${ARTIFACTS_PATH}/modified_config.json"

configtxlator proto_encode --input "${ARTIFACTS_PATH}/config.json" --type common.Config --output "${ARTIFACTS_PATH}/original_config.pb"

configtxlator proto_encode --input "${ARTIFACTS_PATH}/modified_config.json" --type common.Config --output "${ARTIFACTS_PATH}/modified_config.pb"

configtxlator compute_update --channel_id "${CHANNEL_NAME}" --original ${ARTIFACTS_PATH}/original_config.pb --updated ${ARTIFACTS_PATH}/modified_config.pb --output ${ARTIFACTS_PATH}/config_update.pb

configtxlator proto_decode --input "${ARTIFACTS_PATH}/config_update.pb" --type common.ConfigUpdate --output "${ARTIFACTS_PATH}/config_update.json"

UPDATE_CONTENT=$(cat ${ARTIFACTS_PATH}/config_update.json)
echo "{\"payload\":{\"header\":{\"channel_header\":{\"channel_id\":\"${CHANNEL_NAME}\", \"type\":2}},\"data\":{\"config_update\":${UPDATE_CONTENT}}}}" | jq . > ${ARTIFACTS_PATH}/config_update_in_envelope.json

configtxlator proto_encode --input ${ARTIFACTS_PATH}/config_update_in_envelope.json --type common.Envelope --output ${ARTIFACTS_PATH}/anchors.tx

peer channel update \
  --orderer "${ORDERING_SERVICE_GRPC_ADDRESS}" \
  --channelID "${CHANNEL_NAME}" \
  --file ${ARTIFACTS_PATH}/anchors.tx \
  --tls \
  --cafile /opt/gopath/crypto/ordererOrganizations/"${ORDERING_ORG_DOMAIN}"/msp/tlscacerts/tlsca."${ORDERING_ORG_DOMAIN}"-cert.pem

result=$?
if [ $result -ne 0 ]; then
    exit 1
fi
