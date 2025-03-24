apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: grafana-k8s-monitoring-app
  namespace: argocd
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: grafana-k8s-monitoring
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
    path: platform/${tenant_name}/${cluster_id}/argocd-applications/grafana-k8s-monitoring