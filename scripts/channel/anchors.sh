#!/bin/bash

. ./scripts/utils.sh

PEER_ADDRESS="${PEER_ID}:${PEER_PORT}"

title "Setting the anchor peer ${PEER} for the ${ORG_MSP_ID} in the channel ${CHANNEL_NAME}"

info "Fetching the config block from the channel ${CHANNEL_NAME}"
docker exec \
    --env CORE_PEER_TLS_ENABLED=true \
    --env CORE_PEER_LOCALMSPID="${ORG_MSP_ID}" \
    --env CORE_PEER_ID="${PEER_ID}" \
    --env CORE_PEER_ADDRESS="${PEER_ADDRESS}" \
    --env CORE_PEER_MSPCONFIGPATH="${MSP_PATH}" \
    --env CORE_PEER_TLS_ROOTCERT_FILE="${TLS_ROOTCERT_FILE}" \
    "${DOCKER_FABRIC_TOOLS_CONTAINER}" \
    peer channel fetch config "${ARTIFACTS_PATH}"/"${ORG_MSP_ID}"block.pb -o "${ORDERING_SERVICE_ADDRESS}" -c "${CHANNEL_NAME}" --tls --cafile "${ORDERER_CA_FILE}"

result=$?
if [ $result -ne 0 ]; then
    fatal "Failed fetching the config block from the channel ${CHANNEL_NAME}"
fi

info "Decoding the block"
docker exec \
    cli \
    sh -c "configtxlator proto_decode --input ${ARTIFACTS_PATH}/${ORG_MSP_ID}block.pb --type common.Block --output ${ARTIFACTS_PATH}/${ORG_MSP_ID}block.json"

result=$?
if [ $result -ne 0 ]; then
    fatal "Failed decoding config block"
fi

info "Reading configuration payload from the decoded block"
docker exec \
    cli \
    sh -c "cat ${ARTIFACTS_PATH}/${ORG_MSP_ID}block.json | jq .data.data[0].payload.data.config > ${ARTIFACTS_PATH}/${ORG_MSP_ID}config.json"

info "Adding the peer ${PEER_ID} as an anchor to the configuration"
docker exec \
    cli \
    sh -c "jq '.channel_group.groups.Application.groups.'${ORG_MSP_ID}'.values += {\"AnchorPeers\":{\"mod_policy\": \"Admins\",\"value\":{\"anchor_peers\": [{\"host\": \"'${PEER_ID}'\",\"port\": '${PEER_PORT}'}]},\"version\": \"0\"}}' ${ARTIFACTS_PATH}/${ORG_MSP_ID}config.json > ${ARTIFACTS_PATH}/${ORG_MSP_ID}modified_config.json"


info "Encoding the original configuration"
docker exec \
    cli \
    sh -c "configtxlator proto_encode --input ${ARTIFACTS_PATH}/${ORG_MSP_ID}config.json --type common.Config --output ${ARTIFACTS_PATH}/${ORG_MSP_ID}original_config.pb"

info "Encoding modified config"
docker exec \
    cli \
    sh -c "configtxlator proto_encode --input ${ARTIFACTS_PATH}/${ORG_MSP_ID}modified_config.json --type common.Config --output ${ARTIFACTS_PATH}/${ORG_MSP_ID}modified_config.pb"

info "Computing the difference between original and modified configurations"
docker exec \
    cli \
    sh -c "configtxlator compute_update --channel_id ${CHANNEL_NAME} --original ${ARTIFACTS_PATH}/${ORG_MSP_ID}original_config.pb --updated ${ARTIFACTS_PATH}/${ORG_MSP_ID}modified_config.pb --output ${ARTIFACTS_PATH}/${ORG_MSP_ID}config_update.pb"

info "Decoding the difference"
docker exec \
    cli \
    sh -c "configtxlator proto_decode --input ${ARTIFACTS_PATH}/${ORG_MSP_ID}config_update.pb --type common.ConfigUpdate --output ${ARTIFACTS_PATH}/${ORG_MSP_ID}config_update.json"

info "Enveloping the update"
UPDATE_CONTENT=$(docker exec cli sh -c "cat ${ARTIFACTS_PATH}/${ORG_MSP_ID}config_update.json")
docker exec \
    cli \
    sh -c "echo '{\"payload\":{\"header\":{\"channel_header\":{\"channel_id\":\"'$CHANNEL_NAME'\", \"type\":2}},\"data\":{\"config_update\":${UPDATE_CONTENT}}}}' | jq . > ${ARTIFACTS_PATH}/${ORG_MSP_ID}config_update_in_envelope.json"

info "Creating the update transaction"
docker exec \
    cli \
    sh -c "configtxlator proto_encode --input ${ARTIFACTS_PATH}/${ORG_MSP_ID}config_update_in_envelope.json --type common.Envelope --output ${ARTIFACTS_PATH}/${ORG_MSP_ID}anchors.tx"

info "Sending the transaction to the channel"
docker exec \
    --env CORE_PEER_TLS_ENABLED=true \
    --env CORE_PEER_LOCALMSPID="${ORG_MSP_ID}" \
    --env CORE_PEER_ID="${PEER_ID}" \
    --env CORE_PEER_ADDRESS="${PEER_ADDRESS}" \
    --env CORE_PEER_MSPCONFIGPATH="${MSP_PATH}" \
    --env CORE_PEER_TLS_ROOTCERT_FILE="${TLS_ROOTCERT_FILE}" \
    cli \
    peer channel update -o "${ORDERING_SERVICE_ADDRESS}" -c "${CHANNEL_NAME}" -f "${ARTIFACTS_PATH}"/"${ORG_MSP_ID}"anchors.tx --tls --cafile "$ORDERER_CA_FILE"

result=$?
if [ $result -ne 0 ]; then
    error "Failed sending the transaction to the channel ${CHANNEL_NAME}"
fi

println
