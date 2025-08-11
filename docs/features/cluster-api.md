# Integration: Cluster API

kubevirt-manager supports integration with the [KubeVirt Cluster API provider](https://github.com/kubernetes-sigs/cluster-api-provider-kubevirt) to provision tenant Kubernetes clusters inside your KubeVirt environment.

This feature allows you to create and manage nested Kubernetes clusters directly from KubeVirt Manager.

---

## 1. Install Cluster API
Follow the official Cluster API documentation to install and configure the KubeVirt Cluster API provider:
[Cluster API Quick Start Guide](https://cluster-api.sigs.k8s.io/user/quick-start)

## 2. Enable the ClusterResourceSet Feature
The `ClusterResourceSet` feature **must** be enabled for this integration to work.
kubevirt-manager relies on it to automatically provision CNI plugins and additional features inside standard clusters.

Before running clusterctl generate, export the following environment variable:

```sh
export EXP_CLUSTER_RESOURCE_SET=true
```

## 3. Enabling ClusterResourceSet in a Running Controller
If your Cluster API controller is already running, you can enable the feature gate by editing the deployment and adding the `ClusterResourceSet=true` flag to the command-line arguments.

Example deployment snippet:
```yaml
    spec:
      containers:
      - args:
        - --leader-elect
        - --diagnostics-address=:8443
        - --insecure-diagnostics=false
        - --feature-gates=MachinePool=true,ClusterResourceSet=true,ClusterTopology=true,RuntimeSDK=false,MachineSetPreflightChecks=true,MachineWaitForVolumeDetachConsiderVolumeAttachments=true,PriorityQueue=false
        command:
        - /manager
```
         
To edit your running Controller use:

```sh
kubectl edit -n capi-system deployment.apps/capi-controller-manager
```

## 4. Verifying the Integration
Once the setup is done, you should be able to see a `Clusters` option on the left menu.