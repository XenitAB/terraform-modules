apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: grafana-alloy-extras
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  project: ${project}
  destination:
    server: https://kubernetes.default.svc
    namespace: grafana-alloy
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
    path: platform/${tenant_name}/${cluster_id}/argocd-applications/grafana-alloy/manifests