apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: azure-metrics
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "2"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: azure-metrics
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://webdevops.github.io/helm-charts
    targetRevision: v1.2.8
    chart: azure-metrics-exporter
    helm:
      valuesObject:
        fullnameOverride: "azure-metrics-exporter"
        image:
          tag: "24.2.0"
        resources:
          requests:
            cpu: 15m
            memory: 25Mi
        podLabels:
          azure.workload.identity/use: "true"
        serviceAccount:
          # name must correlate with azurerm_federated_identity_credential.azure_metrics.subject
          name: azure-metrics-exporter
          annotations:
            azure.workload.identity/client-id: ${client_id}
        netpol:
          enabled: false