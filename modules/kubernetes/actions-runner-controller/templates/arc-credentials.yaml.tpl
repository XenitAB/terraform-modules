apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: arc-credentials
  namespace: ${tenant_name}-${environment}
  annotations:
    argocd.argoproj.io/manifest-generate-paths: .
    argocd.argoproj.io/sync-wave: "0"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: ${runners_namespace}
  revisionHistoryLimit: 5
  syncPolicy:
%{ if automated ~}
    automated:
      prune: true
      selfHeal: true
%{ endif ~}
    syncOptions:
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
  source:
    repoURL: ${repo_url}
    targetRevision: HEAD
    path: platform/${tenant_name}/${cluster_id}/argocd-applications/actions-runner-controller/manifests/credentials
    directory:
      recurse: false