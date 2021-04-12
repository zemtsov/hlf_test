#!/bin/bash

. env.sh

PATH=${PWD}/bin:$PATH

echo "Creating channel tx"

if [ -d "channel-artifacts" ]; then
    echo "Removing existing artifacts"
    rm -Rf ./channel-artifacts
fi

mkdir -p ./channel-artifacts
configtxgen -configPath ${PWD}/configtx -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME

result=$?
if [ $result -ne 0 ]; then
    echo "Failed creating channel tx"
fi
