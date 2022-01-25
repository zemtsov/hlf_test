.DEFAULT_GOAL := up

.PHONY: update
update: ## Updating dependencies in charts
	cd charts/org; helm dependency update; cd -

.PHONY: cli
cli: ## Starting Fabric Tools
	helm install cli charts/tools -f charts/tools/values.yaml

.PHONY: crypto
crypto:
	$(eval CLI_POD:=$(shell kubectl get pod -l name=cli-fabric-tools -o jsonpath="{.items[0].metadata.name}"))
	kubectl exec $(CLI_POD) -- /opt/gopath/scripts/crypto.sh

.PHONY: network
network: ## Starting the network
	make update
	helm install ordering charts/org -f settings/values-ordering.yaml
	helm install org1 charts/org -f settings/values-org1.yaml
	helm install org2 charts/org -f settings/values-org2.yaml

.PHONY: up
up: ## Starting cli, peers and orderers
	make cli
	make network

.PHONY: down
down: ## Shutting down all resources
	helm uninstall cli
	helm uninstall org1
	helm uninstall org2
	helm uninstall ordering
	helm uninstall hello-chaincode

.PHONY: channel
channel: ## Creating the channel
	$(eval CLI_POD:=$(shell kubectl get pod -l name=cli-fabric-tools -o jsonpath="{.items[0].metadata.name}"))
	kubectl exec $(CLI_POD) -- /opt/gopath/scripts/channel.sh

.PHONY: build
build: ## Installing the chaincode and building it
	$(eval CLI_POD:=$(shell kubectl get pod -l name=cli-fabric-tools -o jsonpath="{.items[0].metadata.name}"))
	kubectl exec $(CLI_POD) -- /opt/gopath/scripts/build.sh
	docker build -t hyperledger/hello:latest chaincode/hello

.PHONY: run
run: ## Running the chaincode
	helm install hello-chaincode charts/chaincode -f settings/values-chaincode.yaml
	$(eval CLI_POD:=$(shell kubectl get pod -l name=cli-fabric-tools -o jsonpath="{.items[0].metadata.name}"))
	kubectl exec $(CLI_POD) -- /opt/gopath/scripts/run.sh

.PHONY: invoke
invoke: ## Invoking the chaincode
	$(eval CLI_POD:=$(shell kubectl get pod -l name=cli-fabric-tools -o jsonpath="{.items[0].metadata.name}"))
	kubectl exec $(CLI_POD) -- /opt/gopath/scripts/invoke.sh
