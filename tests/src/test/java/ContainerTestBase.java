import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.Network;
import org.testcontainers.containers.output.Slf4jLogConsumer;
import org.testcontainers.containers.wait.strategy.Wait;
import sun.nio.ch.Net;

import java.io.File;

public abstract class ContainerTestBase {
    private static final Logger logger = LoggerFactory.getLogger(ContainerTestBase.class);

    private static GenericContainer _container;

    @BeforeClass
    public static void setUp() {
        String dockerImageTag = System.getProperty("image_tag");

        logger.info("Tested Docker image tag: {}", dockerImageTag);

        Network network = Network.builder()
                .createNetworkCmdModifier(c -> c.withDriver("overlay"))
                .createNetworkCmdModifier(c -> c.withAttachable(true))
                .build();

        _container = new GenericContainer<>(dockerImageTag)
                .withEnv("PUID", "0")
                .withEnv("PGID", "0")
                .withEnv("LOG_LEVEL", "debug")
                .withEnv("AGENT_CLUSTER_ADDR", "agent")
                .withNetworkAliases("agent")
                .withNetwork(network)
                .withFileSystemBind("//var/run/docker.sock", "/var/run/docker.sock")
                .waitingFor(Wait.forLogMessage(".*http.*port: 9001\\].*", 1));

        _container.start();
        _container.followOutput(new Slf4jLogConsumer(logger));
    }

    @AfterClass
    public static void cleanUp() {
        _container.stop();
        _container.close();
    }

    protected GenericContainer getContainer() {
        return _container;
    }
}