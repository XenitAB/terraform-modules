%{ if cloud_provider == "azure" }
configuration:
  provider: "azure"
  backupStorageLocation:
    name: "default"
    bucket: "${azure_storage_account_container}"
    config:
      resourceGroup: "${azure_resource_group}"
      storageAccount: "${azure_storage_account_name}"

snapshotsEnable: false 

credentials:
  existingSecret: "velero"

initContainers:
  - name: "velero-plugin-for-microsoft-azure"
    image: "velero/velero-plugin-for-microsoft-azure:1.1.1"
    volumeMounts:
      - mountPath: "/target"
        name: "plugins"

podLabels:
  aadpodidbinding: velero
%{ endif }
