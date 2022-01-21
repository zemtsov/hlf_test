#!/bin/bash

. /opt/gopath/scripts/utils.sh
. /opt/gopath/scripts/env.sh

title "Creating the channel ${CHANNEL_NAME}"

info "Creating the channel ${CHANNEL_NAME} with the ordering node ${ORDERING_SERVICE_REST_ADDRESS}"
/opt/gopath/scripts/channel/create.sh

sleep 1

title "Joining the peer ${ORG1_PEER0_ID} to the channel ${CHANNEL_NAME}"

useOrganization 1
/opt/gopath/scripts/channel/join.sh

info "Setting the anchor peer ${ORG1_PEER0_ID} in the channel ${CHANNEL_NAME}"
/opt/gopath/scripts/channel/update.sh


title "Joining the peer ${ORG2_PEER0_ID} to the channel ${CHANNEL_NAME}"

useOrganization 2
/opt/gopath/scripts/channel/join.sh

info "Setting the anchor peer ${ORG2_PEER0_ID} in the channel ${CHANNEL_NAME}"
/opt/gopath/scripts/channel/update.sh
