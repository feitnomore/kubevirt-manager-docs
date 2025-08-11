# Install: Details

This section provides step-by-step instructions for installing kubevirt-manager manually, giving you full control over the resources being deployed.  
    
*Note:* You can check and edit each yaml file according to your needs.

---

### Clone the Repo
```sh
git clone https://github.com/kubevirt-manager/kubevirt-manager.git
```
### Create the Namespace
```sh
kubectl apply -f kubernetes/ns.yaml
```
### Create the Custom Resource Definition
```sh
kubectl apply -f kubernetes/crd.yaml
```
### Create the Service Account and RBAC
```sh
kubectl apply -f kubernetes/rbac.yaml
```
### Create the Priority Classes
```sh
kubectl apply -f kubernetes/pc.yaml
```
### Create the FrontEnd Deployment
```sh
kubectl apply -f kubernetes/deployment.yaml
```
### Create the FrontEnd Service
```sh
kubectl apply -f kubernetes/service.yaml
```
### Check if kubevirt-manager is running
```sh
kubectl get pods -n kubevirt-manager -o wide
```
### Check kubevirt-manager service
```sh
kubectl get svc -n kubevirt-manager -o wide
```