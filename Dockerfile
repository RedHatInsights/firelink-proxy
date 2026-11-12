# Build stage - compile Caddy from source
FROM registry.access.redhat.com/hi/go:1.26.10-builder@sha256:8534a929a08031ad051058a3573ebd9f2e7c187314e406dc2815070c64c445a2 AS build

WORKDIR /workspace

# Download and build Caddy
# Using a specific version for reproducibility
ARG CADDY_VERSION=v2.9.1

RUN git clone --branch ${CADDY_VERSION} --depth 1 https://github.com/caddyserver/caddy.git && \
    cd caddy/cmd/caddy && \
    go build -trimpath -ldflags="-s -w" -o /workspace/caddy-binary

# Runtime stage - distroless, non-root
FROM registry.access.redhat.com/hi/go:1.26.10@sha256:88a70bbb936157878fd5eff1d1370dcc6370d4c4df7aaf3956f6679e9ba59591

WORKDIR /opt/app-root/src

# Copy Caddy binary from build stage
COPY --from=build --chown=65532:0 /workspace/caddy-binary /usr/local/bin/caddy

# Copy Caddyfile configuration
COPY --chown=65532:0 ./Caddyfile /etc/caddy/Caddyfile

# Set XDG directories to locations Caddy can write to
# Caddy needs these for locks, storage, and config autosave
ENV XDG_DATA_HOME=/tmp/caddy/data \
    XDG_CONFIG_HOME=/tmp/caddy/config

# Expose port 8000 (HTTP, no TLS)
EXPOSE 8000

# Run as non-root user (default in HI images is 65532)
USER 65532

ENTRYPOINT ["/usr/local/bin/caddy", "run", "--config", "/etc/caddy/Caddyfile"]
