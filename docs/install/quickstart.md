# Install: Quickstart

This section will just get you up and running as quickly as possible.

### Install
To get up and running quickly, you can install everything with a single command:

```sh
kubectl apply -f https://github.com/kubevirt-manager/kubevirt-manager/blob/main/kubernetes/bundled.yaml
```

This will:   
1. Create the required namespace and RBAC permissions   
2. Create the necessary CRDs   
3. Deploy the frontend application   
4. Expose it as a Kubernetes Service   

### Verify
Once deployed, you can check that it’s running:
```sh
kubectl get pods -n kubevirt-manager -o wide
```
Also check if the Service is deployed:
```sh
kubectl get svc -n kubevirt-manager -o wide
```