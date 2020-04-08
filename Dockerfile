FROM homecentr/base:1.1.0 as base
FROM portainer/agent:1.5.1 as agent

FROM alpine:3.11.3

ARG PORTAINER_AGENT_VERSION
ENV PORTAINER_AGENT_ARGS=""

LABEL maintainer="Lukas Holota <me@lholota.com>"
LABEL io.homecentr.dependency-version=1.5.1

RUN apk add --no-cache \
    shadow=4.7-r1 \
    curl=7.67.0-r0

# Copy S6 overlay
COPY --from=base / /

# Copy Portainer agent binaries
COPY --from=agent / /

# Copy S6 overlay configuration
COPY ./fs/ /

RUN chmod a+x /usr/sbin/healthcheck && \
    chmod a+x /usr/sbin/wait-for-signal

HEALTHCHECK --interval=10s --timeout=5s --retries=3 CMD healthcheck

WORKDIR /app

EXPOSE 9001

ENTRYPOINT [ "/init" ]
