apiVersion: v1
kind: Namespace
metadata:
 name: velero
 labels:
   name: velero
   xkf.xenit.io/kind: platform
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: velero
  namespace: velero
spec:
  interval: 1m0s
  url: "https://vmware-tanzu.github.io/helm-charts"
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: velero
  namespace: velero
spec:
  chart:
    spec:
      chart: velero
      sourceRef:
        kind: HelmRepository
        name: velero
      version: v2.23.6
  interval: 1m0s
  values:
    configuration:
      provider: "azure"
      logLevel: "warning"
      logFormat: "json"
      backupStorageLocation:
        name: "default"
        bucket: "${azure_config.storage_account_container}"
        config:
          resourceGroup: "${azure_config.resource_group}"
          storageAccount: "${azure_config.storage_account_name}"

    snapshotsEnable: false

    # Yes this is needed even if it duplicates data
    # https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure#option-2-use-aad-pod-identity
    credentials:
    secretContents:
        cloud: |
        AZURE_SUBSCRIPTION_ID=${azure_config.subscription_id}
        AZURE_RESOURCE_GROUP=${azure_config.resource_group}
        AZURE_CLOUD_NAME=AzurePublicCloud

    initContainers:
    - name: "velero-plugin-for-microsoft-azure"
        image: "velero/velero-plugin-for-microsoft-azure:v1.1.1"
        volumeMounts:
        - mountPath: "/target"
            name: "plugins"

    podLabels:
    aadpodidbinding: velero

    priorityClassName: "platform-low"
