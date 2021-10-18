import org.bouncycastle.util.io.pem.PemObject;
import org.bouncycastle.util.io.pem.PemReader;
import org.hyperledger.fabric.gateway.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.concurrent.TimeoutException;

public class JavaGatewaySDKTest {
    private static final Logger logger = LoggerFactory.getLogger(JavaGatewaySDKTest.class);

    public static void main(String[] args) throws IOException {

        logger.info("creating the wallet on the file system");
        Path walletDirectory = Paths.get(Config.ClientWalletPath, Config.ClientMspId);

        Wallet wallet;
        try {
            wallet = Wallets.newFileSystemWallet(walletDirectory);
        } catch (IOException exception) {
            logger.error("failed creating the wallet on the file system: {}", exception.getMessage());
            return;
        }

        try {
            if (wallet.get(Config.ClientUserName) == null) {
                populateWallet(wallet);
            }
        } catch (CertificateException | IOException | NoSuchAlgorithmException | InvalidKeySpecException exception) {
            logger.error("failed getting the identity from the wallet: {}", exception.getMessage());
            return;
        }

        Path connectionProfilePath = Paths.get(Config.ConnectionProfilePath);

        logger.info("connecting the gateway with the connection profile from {}", connectionProfilePath);
        Gateway.Builder builder = Gateway.createBuilder()
                .identity(wallet, Config.ClientUserName)
                .networkConfig(connectionProfilePath)
                .discovery(true);
        try (Gateway gateway = builder.connect()) {
            logger.info("connecting the channel {}", Config.ChannelName);
            Network network = gateway.getNetwork(Config.ChannelName);

            logger.info("obtaining the chaincode {}", Config.ChaincodeName);
            Contract contract = network.getContract(Config.ChaincodeName);

            logger.info("submitting transaction");
            contract.submitTransaction("store", "value1", "value_from_java");

            logger.info("querying the chaincode");
            byte[] result = contract.evaluateTransaction("read", "value1");
            logger.info("the value read from the ledger is {}", new String(result, StandardCharsets.UTF_8));
        } catch (ContractException | InterruptedException | TimeoutException exception) {
            logger.error("error occurred during communicating the network: {}", exception.getMessage());
            exception.printStackTrace();
        }
    }

    private static void populateWallet(Wallet wallet) throws CertificateException, IOException, NoSuchAlgorithmException, InvalidKeySpecException {

        logger.info("creating the new identity for {} of {}", Config.ClientUserName, Config.ClientMspId);

        X509Certificate certificate = readCertificateFromFile();
        PrivateKey privateKey = readPrivateKeyFromFile();

        Identity identity = Identities.newX509Identity(
                Config.ClientMspId,
                certificate,
                privateKey
        );
        logger.info("putting the new identity to the wallet");
        wallet.put(Config.ClientUserName, identity);
    }

    private static X509Certificate readCertificateFromFile() throws FileNotFoundException, CertificateException {

        Path certificatesPath = Paths.get(
                Config.CryptoRootPath,
                "peerOrganizations",
                Config.ClientOrgDomain,
                "users",
                String.format("%s@%s", Config.ClientUserName, Config.ClientOrgDomain),
                "msp",
                "signcerts");

        logger.info("reading the certificate from {}", certificatesPath);
        File certificateDirectory = new File(certificatesPath.toString());
        File[] certificateFiles = certificateDirectory.listFiles();
        if (certificateFiles == null || certificateFiles.length == 0) {
            logger.error("the certificate file not found");
            throw new FileNotFoundException();
        }
        CertificateFactory factory = CertificateFactory.getInstance(Config.CertificateFormat);
        FileInputStream certificateFile = new FileInputStream(certificateFiles[0]);
        return (X509Certificate) factory.generateCertificate(certificateFile);
    }

    private static PrivateKey readPrivateKeyFromFile() throws IOException, NoSuchAlgorithmException, InvalidKeySpecException {

        Path keyStorePath = Paths.get(
                Config.CryptoRootPath,
                "peerOrganizations",
                Config.ClientOrgDomain,
                "users",
                String.format("%s@%s", Config.ClientUserName, Config.ClientOrgDomain),
                "msp",
                "keystore");

        logger.info("reading the private key from {}", keyStorePath);
        File certificateDirectory = new File(keyStorePath.toString());
        File[] keyFiles = certificateDirectory.listFiles();
        if (keyFiles == null || keyFiles.length == 0) {
            logger.error("the private key file not found");
            throw new FileNotFoundException();
        }

        PemReader pemReader = new PemReader(new FileReader(keyFiles[0]));
        PemObject pemObject = pemReader.readPemObject();
        byte[] keyBytes = pemObject.getContent();
        PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(Config.PrivateKeyAlgo);
        return keyFactory.generatePrivate(spec);
    }
}
