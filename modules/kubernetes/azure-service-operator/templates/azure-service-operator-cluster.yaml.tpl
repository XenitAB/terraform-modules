apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: azure-service-operator
  namespace: argocd
spec:
  project: ${project_name}
  destination:
    server: ${server_name}
    namespace: azureserviceoperator-system
  revisionHistoryLimit: 5
  syncPolicy:
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
  sources:
    - repoURL: ${repo_url}
      targetRevision: HEAD
      path: platform/${tenant_name}/${cluster_id}/k8s-manifests/azure-service-operator

    
    
