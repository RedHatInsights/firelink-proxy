FROM quay.io/redhat-services-prod/hcm-eng-prod-tenant/caddy-ubi:0d6954b

ENV CADDY_TLS_MODE http_port 8000

COPY ./Caddyfile /etc/caddy/Caddyfile

CMD ["caddy", "run", "--config", "/opt/app-root/src/Caddyfile"]
