# Install: Requirements

This page will guide you through the configuration tweaks needed to unlock kubevirt-manager’s full potential.

---

## KubeVirt Feature Gates

To take full advantage of kubevirt-manager, you need to enable a few KubeVirt feature gates that allow advanced functionality:

```yaml
      featureGates:
      - HotplugVolumes
      - HostDisk
      - VMExport
      - Snapshot
      - ExpandDisks
      - ExperimentalIgnitionSupport
      - LiveMigration
```

For details on how to enable feature gates, refer to the [KubeVirt Documentation](https://kubevirt.io/user-guide/cluster_admin/activating_feature_gates/).   
You can also check the [detailed list of feature gates](https://github.com/kubevirt/kubevirt/blob/main/pkg/virt-config/featuregate/active.go) in the KubeVirt source code.

## CDI Feature Gates

If you are using [hostpath-provisioner](https://github.com/kubevirt/hostpath-provisioner) CSI, kubevirt-manager requires an additional CDI feature gate to ensure proper functionality:

```yaml
      featureGates:
      - HonorWaitForFirstConsumer
```

Details about this feature gate are available in the [CDI Repository](https://github.com/kubevirt/containerized-data-importer/blob/main/doc/waitforfirstconsumer-storage-handling.md).

## hostpath-provisioner

When using [hostpath-provisioner](https://github.com/kubevirt/hostpath-provisioner) a few more settings are recommended in the StorageClass for proper behavior:  

1. Enable volume expansion – This allows resizing of VM disks:  
      `allowVolumeExpansion: true`

2. Set volume binding mode – This ensures proper workload placement on Kubernetes nodes:  
      `volumeBindingMode: WaitForFirstConsumer`

Here is an example of a complete StorageClass for [hostpath-provisioner](https://github.com/kubevirt/hostpath-provisioner):
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: hostpath-csi
provisioner: kubevirt.io.hostpath-provisioner
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
parameters:
  storagePool: local
```

For more details, see the Kubernetes docs on [Volume Expansion](https://kubernetes.io/docs/concepts/storage/storage-classes/#allow-volume-expansion) and [Volume Binding Modes](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode).




 