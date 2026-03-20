FROM quay.io/redhat-services-prod/hcm-eng-prod-tenant/caddy-ubi:094d8a9

ENV CADDY_TLS_MODE http_port 8000

COPY ./Caddyfile /etc/caddy/Caddyfile

