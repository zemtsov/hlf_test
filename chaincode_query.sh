. env.sh

PATH=${PWD}/bin:$PATH

export FABRIC_CFG_PATH=${PWD}/config


######################################################################
# ORG 1
######################################################################

echo
echo "Querying chaincode ${CC_NAME} from ORG 1"

docker exec \
    -e "CORE_PEER_LOCALMSPID=Org1MSP" \
    -e "CORE_PEER_ID=peer0.org1.example.com" \
    -e "CORE_PEER_ADDRESS=peer0.org1.example.com:7051" \
    -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
    cli \
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args": [""]}' >&log.txt

cat log.txt


######################################################################
# ORG 2
######################################################################

echo
echo "Querying chaincode ${CC_NAME} from ORG 2"

docker exec \
    -e "CORE_PEER_LOCALMSPID=Org2MSP" \
    -e "CORE_PEER_ID=peer0.org2.example.com" \
    -e "CORE_PEER_ADDRESS=peer0.org2.example.com:9051" \
    -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
    cli \
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args": [""]}' >&log.txt

cat log.txt

