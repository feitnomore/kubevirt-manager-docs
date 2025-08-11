# Authentication: Oauth2

KubeVirt Manager supports OAuth2 authentication for secure and centralized user management.
This guide demonstrates how to configure OAuth2 authentication using [oauth2-proxy](https://github.com/oauth2-proxy/oauth2-proxy), with an example setup for Keycloak as the identity provider.

---

## 1. Prerequisites
Before starting, make sure you have:  

  * A working OAuth2 provider (e.g., Keycloak, Google, GitHub, Azure AD) 
  * Client ID and Client Secret from your OAuth2 provider
  * A valid redirect URL configured in your provider settings (e.g., https://kubevirt-manager.my-domain.com/oauth2/callback) 

## 2. Create the OAuth2 Proxy ConfigMap

Replace the placeholders (MY CLIENT_ID, MY_CLIENT_SECRET) and settings (email_domains, cookie_domains, whitelist_domains, redirect_url, oidc_issuer_url, etc) with your actual values:  

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: oauth-config
  namespace: kubevirt-manager
  labels:
    app: kubevirt-manager
    kubevirt-manager.io/version: 1.5.2
    kubevirt-manager.io/managed: "true"
data:
  oauth2.conf: |
    http_address="127.0.0.1:4180"
    cookie_secret="OQINaROshtE9TcZkNAm-5Zs2Pv3xaWytBmc5W7sPX7w="
    email_domains="my-domain.com"
    cookie_secure="true"
    cookie_domains=["kubevirt-manager.my-domain.com"]
    whitelist_domains=[".my-domain.com"]
    client_secret="MY_CLIENT_SECRET"
    client_id="MY CLIENT_ID"
    redirect_url="https://kubevirt-manager.my-domain.com/oauth2/callback"
    oidc_issuer_url="http://keycloak.my-domain.com/realms/master"
    provider="oidc"
    provider_display_name="Keycloak"
    ssl_insecure_skip_verify="true"
    code_challenge_method="S256"
```

You can find more configuration examples in the [oauth2-proxy Keycloak sample](https://github.com/oauth2-proxy/oauth2-proxy/blob/master/contrib/local-environment/oauth2-proxy-keycloak.cfg).

## 3. Configure NGINX to Use OAuth2
Create a ConfigMap `oauth2-configmap.yaml` for the NGINX authentication configuration:  
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: auth-config
  namespace: kubevirt-manager
  labels:
    app: kubevirt-manager
    kubevirt-manager.io/version: 1.5.2
    kubevirt-manager.io/managed: "true"
data:
  oauth2.conf: |
    auth_request /internal-auth/;
    auth_request_set $auth_redirect_url $upstream_http_location;
    auth_request_set $auth_status $upstream_status;
    error_page 401 =403 https://kubevirt-manager.my-domain.com/oauth2/start?rd=https://$host$request_uri;
```

Apply the `oauth2-configmap.yaml` file:
```sh
kubectl apply -f oauth2-configmap.yaml
```

## 4. Restart kubevirt-manager

You should now restart your `kubevirt-manager` Pod. You can do it by deleting the pod from `kubevirt-manager` namespace.