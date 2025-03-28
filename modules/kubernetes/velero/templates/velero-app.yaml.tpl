apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: velero-app
  namespace: ${tenant_name}-${environment}
spec:
  project: ${project}
  destination:
    namespace: ${tenant_name}-${environment}
    server: https://kubernetes.default.svc
  revisionHistoryLimit: 5
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    managedNamespaceMetadata:
      labels:
        xkf.xenit.io/kind: platform
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: ${repo_url}
    targetRevision: HEAD
    path: platform/${tenant_name}/${cluster_id}/argocd-applications/velero