# Build stage - compile Caddy from source
FROM registry.access.redhat.com/hi/go:1.26.10-builder@sha256:784cc9545f11de3ab19c22be7528ef64706c310975778f377c0b0ce62cc053fc AS build

WORKDIR /workspace

# Download and build Caddy
# Using a specific version for reproducibility
ARG CADDY_VERSION=v2.9.1

RUN git clone --branch ${CADDY_VERSION} --depth 1 https://github.com/caddyserver/caddy.git && \
    cd caddy/cmd/caddy && \
    go build -trimpath -ldflags="-s -w" -o /workspace/caddy-binary

# Runtime stage - distroless, non-root
FROM registry.access.redhat.com/hi/go:1.26.10@sha256:937cf018fc7add44cdbb15541f47897e494e68d20f4f9a59b95acb42f4176b11

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
