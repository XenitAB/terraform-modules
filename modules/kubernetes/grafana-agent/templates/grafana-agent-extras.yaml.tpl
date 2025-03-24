apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: grafana-agent-extras
  namespace: argocd
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: grafana-agent
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: ${repo_url}
    targetRevision: HEAD
    path: platform/${tenant_name}/${cluster_id}/argocd-applications/grafana-agent/manifests