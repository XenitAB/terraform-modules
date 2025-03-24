apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: popeye
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "3"
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: popeye
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
    targetRevision: 0.1.0
    chart: popeye