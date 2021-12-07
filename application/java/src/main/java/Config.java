public class Config {
    public static String CryptoRootPath = "../crypto";

    public static String CertificateFormat = "X.509";
    public static String PrivateKeyAlgo = "EC";

    public static String ClientUserName = "User1";
    public static String ClientMspId = System.getenv("ORG1_MSP_ID");
    public static String ClientOrgDomain = System.getenv("ORG1_DOMAIN");
    public static String ClientWalletPath = "wallet";

    public static String ConnectionProfilePath = "connection-org1.yaml";

    public static String ChannelName = System.getenv("CHANNEL_NAME");;
    public static String ChaincodeName = System.getenv("CHAINCODE_NAME");
}
