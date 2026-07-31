FROM quay.io/redhat-services-prod/hcm-eng-prod-tenant/caddy-ubi:dd37f62

ENV CADDY_TLS_MODE http_port 8000

COPY ./Caddyfile /etc/caddy/Caddyfile
