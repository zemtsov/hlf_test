package clientconfig

import "os"

const (
	CryptoRootPath = "../crypto"
)

var (
	ClientMspId     = os.Getenv("ORG1_NAME")
	ClientOrgDomain = os.Getenv("ORG1_DOMAIN")
	ChannelName     = os.Getenv("CHANNEL_NAME")
	ChaincodeName   = os.Getenv("CHAINCODE_NAME")
)

const (
	ClientUserName   = "User1"
	ClientWalletPath = "wallet"
)

const (
	ConnectionProfilePath = "connection-org1.yaml"
)
