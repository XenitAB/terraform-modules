apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: velero
  namespace: argocd
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: velero
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://vmware-tanzu.github.io/helm-charts
    targetRevision: v5.1.5
    chart: velero
    helm:
      valuesObject:
        configuration:
          logLevel: "warning"
          logFormat: "json"
          backupStorageLocation:
          - name: "default"
            provider: azure
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
            image: "velero/velero-plugin-for-microsoft-azure:v1.8.0"
            volumeMounts:
              - mountPath: "/target"
                name: "plugins"
        podLabels:
          azure.workload.identity/use: "true"
        labels:
          azure.workload.identity/use: "true"
        priorityClassName: "platform-low"
        serviceAccount:
          server:
            create: true
            name: velero
            annotations:
              azure.workload.identity/client-id: ${client_id}
              azure.workload.identity/tenant-id: ${tenant_id}
  sources:
  - repoURL: ${repo_url}
    targetRevision: HEAD
    path: platform/${tenant_name}/${cluster_id}/k8s-manifests/velero

