# Install: Ingress

This guide will help you configure an Ingress resource to expose kubevirt-manager externally.   
The example below is based on the [nginx.com Ingress Controller](https://docs.nginx.com/nginx-ingress-controller/installation/installing-nic/installation-with-manifests/).

---

### Example Ingress Manifest

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kubevirt-manager
  namespace: kubevirt-manager
  labels:
    app: kubevirt-manager
    kubevirt-manager.io/version: 1.5.2
spec:
  ingressClassName: my-ingress-class
  tls:
   - hosts:
     - my-host.com
  rules:
  - host: my-host.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: kubevirt-manager
            port:
              number: 8080
```

### WebSocket Headers

To ensure proper WebSocket handling for NoVNC and XTerm.JS, include the following snippet:

```yaml
  annotations:
    nginx.org/location-snippets: |
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
```

### Recommended Annotations

Add the following annotations to optimize performance, timeouts, and enable WebSocket support as well as Oauth2 integration:

```yaml
  annotations:
    nginx.org/client-max-body-size: "20G"
    nginx.org/proxy-read-timeout: "86400s"
    nginx.org/proxy-send-timeout: "86400s"
    nginx.org/send-timeout: "86400s"
    nginx.org/keepalive-timeout: "300s"
    nginx.org/websocket-services: "kubevirt-manager"
    nginx.org/proxy-buffering: "true"
    nginx.org/proxy-buffers: "16 256k"
    nginx.org/proxy-buffer-size: "256k"
    nginx.org/proxy-max-temp-file-size: "102400m"
```
