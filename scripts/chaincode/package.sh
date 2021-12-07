#!/bin/bash

. ./scripts/utils.sh

title "Packaging chaincode ${CHAINCODE_NAME}, version ${CHAINCODE_VERSION}"

info "Removing old chaincode package"
docker exec "${DOCKER_FABRIC_TOOLS_CONTAINER}" rm "${CHAINCODE_PACKAGE}"

info "Creating the chaincode package ${CHAINCODE_NAME}"
docker exec "${DOCKER_FABRIC_TOOLS_CONTAINER}" peer lifecycle chaincode package \
      "${CHAINCODE_PACKAGE}" \
      --path "${CHAINCODE_PATH}" \
      --lang "${CHAINCODE_LANG}" \
      --label "${CHAINCODE_NAME}"_"${CHAINCODE_VERSION}"

result=$?
if [ $result -ne 0 ]; then
    fatal "Failed packaging chaincode ${CHAINCODE_NAME}"
fi

println
