FROM portainer/agent:1.5.1 as agent

FROM homecentr/base:2.4.3-alpine

ENV PORTAINER_AGENT_ARGS=""
ENV FIRST_HEALTHCHECK_TIMEOUT=20

LABEL maintainer="Lukas Holota <me@lholota.com>"
LABEL io.homecentr.dependency-version=1.5.1

RUN apk add --no-cache \
    shadow=4.7-r1 \
    curl=7.67.0-r0

# Copy Portainer agent binaries
COPY --from=agent / /

# Copy S6 overlay configuration
COPY ./fs/ /

RUN chmod a+x /usr/sbin/healthcheck && \
    chmod a+x /usr/sbin/wait-for-signal

# start-period default is zero, when declared explicitly, hadolint check fails so relying on default value
HEALTHCHECK --interval=10s --timeout=5s --retries=3 CMD healthcheck

EXPOSE 9001

ENTRYPOINT [ "/init" ]
