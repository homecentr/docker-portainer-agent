# HomeCentr - portainer-agent

## Healthcheck - why is the start of the container so complicated...

When running in a Swarm cluster, Portainer agent does a DNS lookup to discover other agents. If the container has healthcheck, the DNS record for the container is only added to the Swarm's internal DNS when the healthcheck succeeds. This creates a bit of chicken and egg problem. Healthcheck waits for the agent to start and the agent requires the healthcheck to succeed before it's actually started.

Workaround:
- The healtcheck starts as soon as the container starts and the first execution immedialy succeeds
- Swarm adds record for the container into the internal DNS
- Bash script which is used to start the Portainer agent waits until it gets a signal from healthcheck and only then it actually starts the agent