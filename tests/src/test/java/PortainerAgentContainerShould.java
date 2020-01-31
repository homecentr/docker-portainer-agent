import org.junit.Test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class PortainerAgentContainerShould extends ContainerTestBase {
    /*
    The requests to the agent are done using curl because the native Java implementation
    cannot parse the self-signed certificate Portainer agent generates because it has empty
    Issuer (and probably Subject).
     */

    @Test
    public void RespondOnApiPort() throws IOException, InterruptedException {
        Runtime rt = Runtime.getRuntime();

        String command = String.format("curl -k -i https://%s:%d/ping",
                getContainer().getContainerIpAddress(),
                getContainer().getMappedPort(9001));

        Process ps = rt.exec(command);
        ps.waitFor();

        assertEquals(0, ps.exitValue());

        BufferedReader reader = new BufferedReader(new InputStreamReader(ps.getInputStream()));
        String firstLine = reader.readLine();
        reader.close();

        assertTrue(firstLine.contains(" 204 "));
    }
}
