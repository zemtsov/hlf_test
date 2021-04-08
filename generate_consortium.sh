. env.sh

PATH=${PWD}/bin:$PATH

echo "Creating Genesis block for the ordering service"

configtxgen -configPath ${PWD}/configtx -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./genesis/genesis.block

result=$?
if [ $result -ne 0 ]; then
    echo "Failed creating genesis block for the ordering service"
fi

