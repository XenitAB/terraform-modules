apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: popeye
  namespace: argocd
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: popeye
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: ${repo_url}
    targetRevision: 0.1.0
    chart: popeye