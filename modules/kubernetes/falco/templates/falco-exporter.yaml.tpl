apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: falco-exporter
  namespace: argocd
spec:
  project: ${project}
  destination:
    server: ${server}
    namespace: falco
  revisionHistoryLimit: 5
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - RespectIgnoreDifferences=true
    - ApplyOutOfSyncOnly=true
    - Replace=true
  source:
    repoURL: https://falcosecurity.github.io/charts
    targetRevision: v0.12.1
    chart: falco-exporter
    helm:
      valuesObject:
        priorityClassName: platform-high
