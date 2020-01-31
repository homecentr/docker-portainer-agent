FROM homecentr/base:1.0.0 as base
FROM portainer/agent:1.5.1 as agent

FROM alpine:3.11.3

ENV PORTAINER_AGENT_ARGS=""

RUN apk add --no-cache \
  shadow=4.7-r1 \
  curl=7.67.0-r0

# Copy S6 overlay
COPY --from=base / /

# Copy Portainer agent binaries
COPY --from=agent / /

# Copy S6 overlay configuration & scripts
COPY ./fs/ /

HEALTHCHECK --interval=10s --timeout=10s --start-period=5s --retries=3 CMD [ "curl", "-k", "https://127.0.0.1:9001/ping" ]

EXPOSE 9001

ENTRYPOINT [ "/init" ]