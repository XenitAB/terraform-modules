apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: envoy-gateway-extras
  namespace: envoy-gateway
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "1"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: envoy-gateway
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
    path: platform/${tenant_name}/${cluster_id}/argocd-applications/envoy-gateway/manifests