ARG PORTAINER_AGENT_VERSION="1.5.1"

FROM homecentr/base:1.0.0 as base
FROM portainer/agent:1.5.1 as agent

FROM alpine:3.11.3

ARG PORTAINER_AGENT_VERSION
ENV PORTAINER_AGENT_ARGS=""

LABEL maintainer="Lukas Holota <me@lholota.com>"
LABEL org.homecentr.dependency-version=$PORTAINER_AGENT_VERSION

RUN apk add --no-cache \
    shadow=4.7-r1 \
    curl=7.67.0-r0

# Copy S6 overlay
COPY --from=base / /

# Copy Portainer agent binaries
COPY --from=agent / /

# Copy S6 overlay configuration
COPY ./fs/ /

# Why is healthcheck causing this issue:
# Container is not registered into internal DNS until it has a passing healthcheck
# Echo should work immediatealy (????)
# Healthcheck script shouldn't wait, it should return 0 status code immediately
#   --> no wait time/start period should be zero to allow the registration to DNS

# Solution
# - HC runs first and creates a signal (e.g. a file)
# - Docker registers the DNS alias
# - The run script waits for the signal (e.g. a file) and only then let's the Portainer agent start
# - Portainer agent starts and successfully resolves the DNS records


HEALTHCHECK --interval=10s --timeout=5s --start-period=1ms --retries=3 CMD healthcheck

WORKDIR /app

EXPOSE 9001

ENTRYPOINT [ "/init" ]


# ARG PORTAINER_AGENT_VERSION="1.5.1"

# FROM homecentr/base:1.0.0 as base
# FROM portainer/agent:$PORTAINER_AGENT_VERSION as agent

# FROM alpine:3.11.3

# ARG PORTAINER_AGENT_VERSION
# ENV PORTAINER_AGENT_ARGS=""

# LABEL maintainer="Lukas Holota <me@lholota.com>"
# LABEL org.homecentr.dependency-version=$PORTAINER_AGENT_VERSION

# RUN apk add --no-cache \
#   shadow=4.7-r1 \
#   curl=7.67.0-r0

# # Copy S6 overlay
# COPY --from=base / /

# # Copy Portainer agent binaries
# COPY --from=agent / /

# # Copy S6 overlay configuration & scripts
# COPY ./fs/ /

# HEALTHCHECK --interval=10s --timeout=10s --start-period=5s --retries=3 CMD [ "curl", "-k", "https://127.0.0.1:9001/ping" ]

# EXPOSE 9001

# ENTRYPOINT [ "/init" ]