# Firelink Proxy
An OAuth and TLS proxy for Firelink.


# About
This project provides 2 simple proxies that work together to allow Firelink to run securely on OpenShift and exposed to the internet. The first proxy is [OpenShift OAuth Proxy](https://github.com/openshift/oauth-proxy) which handles authentication and the OAuth flow. After authentication is routes requests to its upstream: the firelink-proxy which is a Caddy reverse proxy running as a seperate container in the same pod. The firelink-proxy routes requests to the frontend and backend pods. This ensures that both the frontend app and backend APIs are behind OAuth, without either app needing to implement the OAuth flow themselves.

# Usage

To test in an ephemeral environment:

```bash
$ oc apply -f deploy/secret.yaml -n $NS
$ oc process -f deploy/deploy.yaml | oc apply -n $NS -f -
```

When you deploy IRL you'll need the secret named `firelink-proxy` created elsewhere as it isn't in the template.
