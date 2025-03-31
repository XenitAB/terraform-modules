apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: prometheus-extras
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/sync-wave: "3"
spec:
  project: ${project}
  destination:
    server: https://kubernetes.default.svc
    namespace: prometheus
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
    path: platform/${tenant_name}/${cluster_id}/argocd-applications/prometheus/manifests