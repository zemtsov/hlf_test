include .env
export $(shell sed 's/=.*//' .env)

.DEFAULT_GOAL := up

clean:
	./scripts/clean.sh

.PHONY: config
config:
	make clean
	./scripts/config.sh

.PHONY: crypto
crypto:  ## Generates crypto materials
	./scripts/crypto.sh

.PHONY: network
network:  ## Starts the network nodes
	./scripts/start.sh

channel:  ## Creates the channel and joins all the peers to it
	./scripts/channel.sh

.PHONY: chaincode
chaincode:
	./scripts/chaincode.sh

restart:
	make down
	make up

test:
	./scripts/test.sh

up:  ## Brings the network up
	make network
	sleep 2
	make channel
	make chaincode
	make test

down:  ## Stops the network
	./scripts/stop.sh
