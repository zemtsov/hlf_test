#!/bin/bash

. ./scripts/utils.sh
. ./scripts/env.sh

title "Generating crypto materials and artifacts"


if [ -d "${CRYPTO_PATH}"/peerOrganizations ]; then
  info "Removing old peer organizations materials"
  rm -rf "${CRYPTO_PATH}"/peerOrganizations
fi
if [ -d "${CRYPTO_PATH}"/ordererOrganizations ]; then
  info "Removing old ordering organizations materials"
  rm -rf "${CRYPTO_PATH}"/ordererOrganizations
fi

info "Generating new crypto materials for organizations"
cryptogen generate \
      --config="${CRYPTO_PATH}"/cryptogen.yaml \
      --output="${CRYPTO_PATH}"


if [ -f "${ARTIFACTS_PATH}"/"${CHANNEL_NAME}".block ]; then
  info "Removing old genesis block file ${ARTIFACTS_PATH}/${CHANNEL_NAME}.block"
  rm "${ARTIFACTS_PATH}"/"${CHANNEL_NAME}".block
fi

info "Generating the genesis block for the channel ${CHANNEL_NAME}"
configtxgen \
      -configPath "${CRYPTO_PATH}" \
      -profile "${GENESIS_BLOCK_PROFILE}" \
      -outputBlock "${ARTIFACTS_PATH}"/"${CHANNEL_NAME}".block \
      -channelID "${CHANNEL_NAME}"
