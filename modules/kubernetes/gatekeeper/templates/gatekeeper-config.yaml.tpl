apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: gatekeeper-config
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
    namespace: gatekeeper-system
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
  ignoreDifferences:
    - group: config.gatekeeper.sh
      kind: Config
      jqPathExpressions:
        - .metadata.labels
    - group: constraints.gatekeeper.sh
      kind: '*'
      jqPathExpressions:
        - .metadata.labels
    - group: mutations.gatekeeper.sh
      kind: Assign
      jqPathExpressions:
        - .metadata.labels
    - group: mutations.gatekeeper.sh
      kind: ModifySet
      jqPathExpressions:
        - .metadata.labels
  source:
    repoURL: ${repo_url}
    targetRevision: HEAD
    path: platform/${tenant_name}/${cluster_id}/argocd-applications/gatekeeper/manifests/config