import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.output.Slf4jLogConsumer;
import org.testcontainers.containers.wait.strategy.Wait;

import java.io.File;

public abstract class ContainerTestBase {
    private static final Logger logger = LoggerFactory.getLogger(ContainerTestBase.class);

    private static GenericContainer _container;

    @BeforeClass
    public static void setUp() {
        String dockerImageTag = System.getProperty("image_tag");

        logger.info("Tested Docker image tag: {}", dockerImageTag);

        String path = new File("//var/run/docker.sock").toURI().toString();

        logger.info("PATH: " + path);

        _container = new GenericContainer<>(dockerImageTag)
                .withFileSystemBind("//var/run/docker.sock", "/var/run/docker.sock")
                .waitingFor(Wait.forHealthcheck());

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