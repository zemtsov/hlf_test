#!/bin/bash

. ./scripts/utils.sh

PEER_ADDRESS="${PEER_ID}:${PEER_PORT}"

title "Approving the chaincode ${CHAINCODE_NAME} by ${ORG_MSP_ID}"

info "Querying the list of installed chaincodes on ${PEER_URL}"
INSTALLED_CHAINCODES=$(docker exec \
    --env CORE_PEER_TLS_ENABLED=true \
    --env CORE_PEER_LOCALMSPID="${ORG_MSP_ID}" \
    --env CORE_PEER_ID="${PEER_ID}" \
    --env CORE_PEER_ADDRESS="${PEER_ADDRESS}" \
    --env CORE_PEER_MSPCONFIGPATH="${MSP_PATH}" \
    --env CORE_PEER_TLS_ROOTCERT_FILE="${TLS_ROOTCERT_FILE}" \
    "${DOCKER_FABRIC_TOOLS_CONTAINER}" \
    peer lifecycle chaincode queryinstalled)

PACKAGE_ID=$(echo "${INSTALLED_CHAINCODES}" | sed -n "/${CHAINCODE_NAME}_${CHAINCODE_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}")

if [ -z "${PACKAGE_ID}" ]
then
    fatal "The chaincode package (${CHAINCODE_NAME}, version ${CHAINCODE_VERSION}) not found"
fi

info "Chaincode package ID: ${PACKAGE_ID}"

info "Approving the chaincode ${CHAINCODE_NAME} from ${PEER_ADDRESS}"
docker exec \
    --env CORE_PEER_TLS_ENABLED=true \
    --env CORE_PEER_LOCALMSPID="${ORG_MSP_ID}" \
    --env CORE_PEER_ID="${PEER_ID}" \
    --env CORE_PEER_ADDRESS="${PEER_ADDRESS}" \
    --env CORE_PEER_MSPCONFIGPATH="${MSP_PATH}" \
    --env CORE_PEER_TLS_ROOTCERT_FILE="${TLS_ROOTCERT_FILE}" \
    "${DOCKER_FABRIC_TOOLS_CONTAINER}" \
    peer lifecycle chaincode approveformyorg \
          --orderer "${ORDERING_SERVICE_NODE_ADDRESS}" \
          --tls --cafile "${ORDERING_CA_FILE}" \
          --channelID "${CHANNEL_NAME}" \
          --name "${CHAINCODE_NAME}" \
          --version "${CHAINCODE_VERSION}" \
          --package-id "${PACKAGE_ID}" \
          --sequence "${CHAINCODE_VERSION}" \
          "${CHAINCODE_INIT}" \
          --signature-policy "${ENDORSEMENT_POLICY}"

result=$?
if [ $result -ne 0 ]; then
    fatal "Failed approving the chaincode ${CHAINCODE_NAME} by the organization ${ORG_MSP_ID} on the peer ${PEER}"
fi

println
