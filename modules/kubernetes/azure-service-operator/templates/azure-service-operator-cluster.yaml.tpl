apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: azure-service-operator-cluster
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "0"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: azureserviceoperator-system
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
    repoURL: https://raw.githubusercontent.com/Azure/azure-service-operator/main/v2/charts
    targetRevision: v2.7.0
    chart: azure-service-operator
    helm:
      valuesObject:
        azureSyncPeriod: "${sync_period}"
        crdPattern: "${crd_pattern}"
        metrics:
          enable: ${enable_metrics}
        networkPolicies:
          enable: false

    
    
