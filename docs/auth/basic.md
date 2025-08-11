# Authentication: HTTP Basic

KubeVirt Manager supports HTTP Basic Authentication for securing access to its web-based UI.   
This guide will walk you through creating and configuring an .htpasswd file to enable authentication in your environment.  

---

## 1. Installing htpasswd

Debian based linux:

```sh
sudo apt-get install apache2-utils
```

RedHat based linux:

```sh
sudo yum install httpd-tools
```

## 2. Creating the .htpasswd File

Run the command below, replacing `<username>` with your desired username:

```sh
htpasswd -c /tmp/htpasswd-file <username>
```

Example `.htpasswd` file content:

```sh
admin:$apr1$bmlZEqez$TXbZ0UWUvYlMTA85qzInd/
```

## 3. Creating the ConfigMap

Create a `auth-basic.yaml` file:
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
    basicauth.conf: |
    auth_basic "Restricted Content";
    auth_basic_user_file /etc/nginx/secret.d/.htpasswd;
```

Apply the `auth-basic.yaml` file:
```sh
kubectl apply -f auth-basic.yaml
```

## 4. Encoding the .htpasswd File

Convert the `.htpasswd` file to Base64:

```sh
cat htpasswd-file | base64 -w0
```

## 5. Creating the Secret

Create a `auth-secret.yaml` file replacing the encoded string below with your own Base64 output from the previous step:

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: auth-secret
    namespace: kubevirt-manager
    labels:
    app: kubevirt-manager
    kubevirt-manager.io/version: 1.5.2
    kubevirt-manager.io/managed: "true"
data:
    .htpasswd: YWRtaW46JGFwcjEkYm1sWkVxZXokVFhiWjBVV1V2WWxNVEE4NXF6SW5kLwo=
```

Apply the `auth-secret.yaml` file:
```sh
kubectl apply -f auth-secret.yaml
```

## 6. Restart kubevirt-manager

You should now restart your `kubevirt-manager` Pod. You can do it by deleting the pod from `kubevirt-manager` namespace.