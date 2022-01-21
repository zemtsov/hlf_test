# Running Hyperledger Fabric in k8s

## Folders

`artifacts` contains the channel's genesis block file. This directory is mapping into the Fabric Tools pod (cli).

`chaincode` contains the source code of chaincodes. `chaincode/sampleBuilder` contains scripts for 
the chaincode external builder. This directory is mapping into peers and the Fabric Tools container (cli).

`charts` contains helm charts for the network nodes (peers, orderers, chaincodes).

`config` contains modified `core.yaml` files which is mapped into peers.

`crypto` contains cryptographic material for organizations. There are also config files for generating the materials
and the channel's genesis block.

`scripts` contains scripts running through the process. This directory is mapping into the Fabric Tools pod (cli).
The file `env.sh` defines environment variables required for working with the network.

`settings` contains values files for the helm charts installing.

## Steps

`make up` brings up peers, ordering service node and the Fabric Tools pod (cli).

`make channel` created the channel, joins peers to the channel and updates anchor peers addresses in the channel's configuration.

`make build` creates the chaincode package, installs it on peers and builds the chaincode image. IMPORTANT: after this command
find the package id in logs (looks like `hello_1:471d134be8240a91716f0a62d20bdfea39e64083d8cb5f08b992808d51b9f9ab`) and 
put it into the chaincode chart values (`settings/values-chaincode.yaml`).

`make run` starts the chaincode pod, approves the chaincode package and commits it to the channel.

`make invoke` invokes the chaincode and queries it from peers.
