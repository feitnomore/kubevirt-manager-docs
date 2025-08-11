# Integration: Prometheus

KubeVirt Manager can integrate with Prometheus to display virtual machine metrics such as CPU, memory, storage, and network usage.

This integration assumes Prometheus is already exposing the following metrics:

  * kubevirt_vmi_storage_write_traffic_bytes_total
  * kubevirt_vmi_storage_read_traffic_bytes_total
  * kubevirt_vmi_network_transmit_bytes_total
  * kubevirt_vmi_network_receive_bytes_total
  * kube_pod_container_resource_requests
  * kubevirt_vmi_memory_domain_total_bytes

These metrics are provided by KubeVirt and kube-state-metrics.

Reference: [Prometheus Monitoring with KubeVirt](https://kubevirt.io/user-guide/user_workloads/component_monitoring/)

---
## 1. Configure Prometheus to Monitor KubeVirt

If you are using **prometheus-operator**, a `ServiceMonitor` definition for KubeVirt is available at `kubernetes/servicemonitor.yaml`.
You must update the **namespace** in the ServiceMonitor and also configure your KubeVirt resource to match:

```yaml
spec:
  monitorNamespace: monitoring
```

## 2. Create the Prometheus Proxy Configuration

To allow kubevirt-manager to query Prometheus, create a ConfigMap file `prometheus-configmap.yaml` that configures NGINX to forward requests to your Prometheus service:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
    name: prometheus-config
    namespace: kubevirt-manager
    labels:
    app: kubevirt-manager
    kubevirt-manager.io/version: 1.5.2
    kubevirt-manager.io/managed: "true"
data:
    prometheus.conf: |
      location /api {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Authorization "";
        proxy_pass_request_body on;
        proxy_pass_request_headers on;
        client_max_body_size 5g;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_pass http://prometheus-service.prometheus-namespace.svc:9090;
      }
```

*Note:*  Replace `prometheus-service` and `prometheus-namespace` with your actual Prometheus service name and namespace.

Apply the `prometheus-configmap.yaml` file:
```sh
kubectl apply -f prometheus-configmap.yaml
```

## 3. Restart kubevirt-manager

You should now restart your `kubevirt-manager` Pod. You can do it by deleting the pod from `kubevirt-manager` namespace.
