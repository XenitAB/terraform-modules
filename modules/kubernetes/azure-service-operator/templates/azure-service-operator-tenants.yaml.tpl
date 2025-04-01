apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: azure-service-operator-tenants
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "1"
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
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: ${repo_url}
    targetRevision: HEAD
    path: platform/${tenant_name}/${cluster_id}/argocd-applications/azure-service-operator/manifests