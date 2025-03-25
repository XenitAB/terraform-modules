apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: azure-service-operator-app
  namespace: argocd
spec:
  project: ${project}
  destination:
    server: https://kubernetes.default.svc
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
    repoURL: ${repo_url}
    targetRevision: HEAD
    path: platform/${tenant_name}/${cluster_id}/argocd-applications/azure-service-operator