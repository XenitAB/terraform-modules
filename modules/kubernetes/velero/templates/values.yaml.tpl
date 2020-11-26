%{ if cloud_provider == "azure" }
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
%{ endif }

%{ if cloud_provider == "aws" }
configuration:
  provider: "aws"
  logLevel: "warning"
  logFormat: "json"
  backupStorageLocation:
    name: "default"
    bucket: "${aws_config.s3_bucket_id}"
    config:
      region: "${aws_config.region}"

snapshotsEnable: false

securityContext:
  fsGroup: 1337

serviceAccount:
  server:
    annotations:
      eks.amazonaws.com/role-arn: ${aws_config.role_arn}

initContainers:
  - name: velero-plugin-for-aws
    image: velero/velero-plugin-for-aws:v1.1.0
    volumeMounts:
      - mountPath: "/target"
        name: "plugins"
%{ endif }
