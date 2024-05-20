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
        %{ if azure_config.storage_account_container != "" }
        bucket: "${azure_config.storage_account_container}"
        %{ else }
        bucket: "backup"
        %{ endif }
        config:
          resourceGroup: "${resource_group_name}"
          %{ if azure_config.storage_account_name != "" }
          storageAccount: "${azure_config.storage_account_name}"
          %{ else }
          storageAccount: "strg${environment}velero${unique_suffix}"
          %{ endif }
    snapshotsEnable: false
    credentials:
      secretContents:
          cloud: |
            AZURE_SUBSCRIPTION_ID=${subscription_id}
            AZURE_RESOURCE_GROUP=${resource_group_name}
            AZURE_CLOUD_NAME=AzurePublicCloud
    initContainers:
      - name: "velero-plugin-for-microsoft-azure"
        image: "velero/velero-plugin-for-microsoft-azure:v1.1.1"
        volumeMounts:
          - mountPath: "/target"
            name: "plugins"
    podLabels:
      azure.workload.identity/use: "true"
    priorityClassName: "platform-low"
    serviceAccount:
      server:
        create: true
        name: velero
        annotations:
          azure.workload.identity/client-id: ${client_id}
