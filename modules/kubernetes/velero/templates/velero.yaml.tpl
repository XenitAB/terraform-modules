apiVersion: v1
kind: Namespace
metadata:
 name: velero
 labels:
   name              = "velero"
   xkf.xenit.io/kind = "platform"
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: velero
  namespace: velero
spec:
  type: "oci"
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
        name: spegel
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
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: velero-extras
  namespace: velero
spec:
  chart:
    spec:
      chart: velero-extras
      sourceRef:
        kind: HelmRepository
        name: spegel
      version: v0.1.0
  interval: 1m0s
  values:
    nameOverride: ""
    fullnameOverride: ""
    resourceID: "${resource_id}"
    clientID: "${client_id}"
---
apiVersion: velero.io/v1
kind: Schedule
metadata:
  name: daily-full-backups
  labels:
    frequency: daily
    full: "true"
spec:
  schedule: "0 2 * * *"
  template:
    ttl: 960h0m0s
---
apiVersion: velero.io/v1
kind: Schedule
metadata:
  name: hourly-minimal-backups
  labels:
    frequency: hourly
    full: "false"
spec:
  schedule: "15 */1 * * *"
  template:
    snapshotVolumes: false
    ttl: 960h0m0s
---
%{ if resource_id != "" && client_id != "" ~}
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentity
metadata:
  name: velero
spec:
  type: 0
  resourceID: ${resource_id}
  clientID: ${client_id}
---
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentityBinding
metadata:
  name: velero
spec:
  azureIdentity: velero
  selector: velero
%{ endif }